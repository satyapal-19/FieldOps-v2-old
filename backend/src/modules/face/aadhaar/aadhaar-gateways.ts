import { readFileSync } from 'node:fs';
import { SignedXml } from 'xml-crypto';
import { AppError } from '../../../shared/errors/app-error';
import { ErrorCode } from '../../../shared/errors/error-codes';

/**
 * The three things only SMKC can provide when it switches to Aadhaar, each behind an
 * interface so it can be plugged in without touching the attendance engine:
 *  1. AadhaarIdentityResolver - staff ID -> UID token / VID (from SMKC's Aadhaar Data Vault)
 *  2. AuthXmlSigner           - signs the Auth XML with SMKC's AUA certificate
 *  3. AsaClient               - sends the signed XML through SMKC's ASA
 */

export abstract class AadhaarIdentityResolver {
  /** UID token, VID or vault-resolved Aadhaar reference; null if the person is not enrolled. */
  abstract resolve(staffId: string): Promise<string | null>;
}

export abstract class AuthXmlSigner {
  abstract sign(xml: string): string;
}

export abstract class AsaClient {
  abstract send(url: string, signedXml: string): Promise<string>;
}

function notConfigured(what: string): AppError {
  return new AppError(ErrorCode.FACE_PROVIDER_UNAVAILABLE, `Aadhaar face authentication is not configured: ${what}`, {
    provider: 'aadhaar',
  });
}

/** Default until SMKC connects its Aadhaar Data Vault. */
export class UnconfiguredIdentityResolver extends AadhaarIdentityResolver {
  async resolve(): Promise<string | null> {
    throw notConfigured('identity resolver (Aadhaar Data Vault)');
  }
}

export class UnconfiguredSigner extends AuthXmlSigner {
  sign(): string {
    throw notConfigured('AUA signing certificate');
  }
}

/**
 * W3C enveloped XML signature with the AUA's Class II/III certificate (KeyInfo carries the
 * X.509 certificate). Validate against UIDAI pre-production before go-live.
 */
export class XmlDsigSigner extends AuthXmlSigner {
  private readonly privateKey: string;
  private readonly publicCert: string;

  constructor(privateKeyPath: string, certificatePath: string) {
    super();
    this.privateKey = readFileSync(privateKeyPath, 'utf8');
    this.publicCert = readFileSync(certificatePath, 'utf8');
  }

  sign(xml: string): string {
    const signer = new SignedXml({
      privateKey: this.privateKey,
      publicCert: this.publicCert,
      canonicalizationAlgorithm: 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315',
      signatureAlgorithm: 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256',
    });
    signer.addReference({
      xpath: "/*[local-name(.)='Auth']",
      digestAlgorithm: 'http://www.w3.org/2001/04/xmlenc#sha256',
      transforms: ['http://www.w3.org/2000/09/xmldsig#enveloped-signature'],
      isEmptyUri: true,
    });
    signer.computeSignature(xml);
    return signer.getSignedXml();
  }
}

/** HTTPS POST to the ASA (static IP / private link arranged by SMKC). */
export class HttpAsaClient extends AsaClient {
  constructor(private readonly timeoutMs: number) {
    super();
  }

  async send(url: string, signedXml: string): Promise<string> {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), this.timeoutMs);
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/xml' },
        body: signedXml,
        signal: controller.signal,
      });
      const body = await response.text();
      if (!response.ok) {
        throw new AppError(ErrorCode.FACE_PROVIDER_UNAVAILABLE, 'ASA rejected the request', {
          provider: 'aadhaar',
          status: response.status,
        });
      }
      return body;
    } catch (error) {
      if (error instanceof AppError) throw error;
      throw new AppError(ErrorCode.FACE_PROVIDER_UNAVAILABLE, 'Could not reach the ASA', { provider: 'aadhaar' });
    } finally {
      clearTimeout(timer);
    }
  }
}
