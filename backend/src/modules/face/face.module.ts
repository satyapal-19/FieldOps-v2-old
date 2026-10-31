import { Logger, Module } from '@nestjs/common';
import { AppConfig } from '../../shared/config/app-config';
import { IdGenerator } from '../../shared/ids/id-generator';
import { AadhaarFaceVerifier } from './aadhaar/aadhaar-face.verifier';
import {
  AadhaarIdentityResolver,
  AsaClient,
  AuthXmlSigner,
  HttpAsaClient,
  UnconfiguredIdentityResolver,
  UnconfiguredSigner,
  XmlDsigSigner,
} from './aadhaar/aadhaar-gateways';
import { FaceController } from './face.controller';
import { FaceVerifier } from './face-verifier';
import {
  EmptyFaceTemplateStore,
  FaceEngine,
  FaceTemplateStore,
  LocalFaceVerifier,
  UnavailableFaceEngine,
} from './local/local-face.verifier';

/**
 * Face verification with a configuration switch (FACE_PROVIDER):
 *   local   -> LocalFaceVerifier   (AuraFace pipeline; engine + templates arrive in Phase 2)
 *   aadhaar -> AadhaarFaceVerifier (UIDAI FaceRD + Auth API via SMKC's ASA)
 * To plug in a real implementation, override the matching provider token below.
 */
@Module({
  controllers: [FaceController],
  providers: [
    { provide: FaceEngine, useClass: UnavailableFaceEngine },
    { provide: FaceTemplateStore, useClass: EmptyFaceTemplateStore },
    { provide: AadhaarIdentityResolver, useClass: UnconfiguredIdentityResolver },
    {
      provide: AuthXmlSigner,
      inject: [AppConfig],
      useFactory: (config: AppConfig): AuthXmlSigner =>
        config.faceProvider === 'aadhaar'
          ? new XmlDsigSigner(config.aadhaar.signingKeyPath, config.aadhaar.signingCertPath)
          : new UnconfiguredSigner(),
    },
    {
      provide: AsaClient,
      inject: [AppConfig],
      useFactory: (config: AppConfig): AsaClient => new HttpAsaClient(config.aadhaar.timeoutMs),
    },
    {
      provide: FaceVerifier,
      inject: [AppConfig, FaceEngine, FaceTemplateStore, AadhaarIdentityResolver, AuthXmlSigner, AsaClient, IdGenerator],
      useFactory: (
        config: AppConfig,
        engine: FaceEngine,
        templates: FaceTemplateStore,
        identities: AadhaarIdentityResolver,
        signer: AuthXmlSigner,
        asa: AsaClient,
        ids: IdGenerator,
      ): FaceVerifier => {
        new Logger('Face').log(`Face verification provider: ${config.faceProvider}`);
        if (config.faceProvider === 'aadhaar') {
          return new AadhaarFaceVerifier(config.aadhaar, identities, signer, asa, ids);
        }
        return new LocalFaceVerifier(engine, templates, config.localFace);
      },
    },
  ],
  exports: [FaceVerifier],
})
export class FaceModule {}
