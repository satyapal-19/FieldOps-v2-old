import { validateEnv } from './env.validation';

const base = {
  DB_HOST: 'localhost',
  DB_USERNAME: 'fieldops',
  DB_PASSWORD: 'secret',
  DB_NAME: 'fieldops_dev',
};

const strongSecret = 'x'.repeat(32);

describe('validateEnv', () => {
  it('applies defaults and converts types in development', () => {
    const env = validateEnv({ ...base, NODE_ENV: 'development', PORT: '4000', DB_SSL: 'false' });
    expect(env.PORT).toBe(4000);
    expect(env.DB_SSL).toBe(false);
    expect(env.DB_PORT).toBe(5432);
    expect(env.SWAGGER_ENABLED).toBe(true);
    expect(env.AUTH_TEST_LOGIN_ENABLED).toBe(false);
  });

  it('defaults the Oracle port and requires a service name', () => {
    expect(() =>
      validateEnv({ ...base, NODE_ENV: 'development', DB_TYPE: 'oracle', DB_NAME: undefined }),
    ).toThrow(/DB_SERVICE_NAME/);
    const env = validateEnv({ ...base, NODE_ENV: 'development', DB_TYPE: 'oracle', DB_SERVICE_NAME: 'XEPDB1' });
    expect(env.DB_PORT).toBe(1521);
  });

  it('refuses test login in production', () => {
    expect(() =>
      validateEnv({
        ...base,
        NODE_ENV: 'production',
        CORS_ORIGINS: 'https://fieldops.example',
        AUTH_TEST_LOGIN_ENABLED: 'true',
        JWT_ACCESS_SECRET: strongSecret,
        JWT_REFRESH_SECRET: strongSecret,
      }),
    ).toThrow(/AUTH_TEST_LOGIN_ENABLED must be false in production/);
  });

  it('requires CORS origins and strong secrets in production, and lists every problem', () => {
    let message = '';
    try {
      validateEnv({ ...base, NODE_ENV: 'production', JWT_ACCESS_SECRET: 'short' });
    } catch (e) {
      message = (e as Error).message;
    }
    expect(message).toMatch(/CORS_ORIGINS/);
    expect(message).toMatch(/JWT_ACCESS_SECRET/);
    expect(message).toMatch(/JWT_REFRESH_SECRET/);
  });

  it('accepts a complete production configuration with Swagger off by default', () => {
    const env = validateEnv({
      ...base,
      NODE_ENV: 'production',
      CORS_ORIGINS: 'https://fieldops.example',
      JWT_ACCESS_SECRET: strongSecret,
      JWT_REFRESH_SECRET: strongSecret,
    });
    expect(env.SWAGGER_ENABLED).toBe(false);
    expect(env.AUTH_TEST_LOGIN_ENABLED).toBe(false);
  });

  it('defaults to the local face provider and requires Aadhaar settings only when switched on', () => {
    expect(validateEnv({ ...base, NODE_ENV: 'development' }).FACE_PROVIDER).toBe('local');
    expect(() => validateEnv({ ...base, NODE_ENV: 'development', FACE_PROVIDER: 'aadhaar' })).toThrow(
      /AADHAAR_AUA_CODE/,
    );
    const env = validateEnv({
      ...base,
      NODE_ENV: 'development',
      FACE_PROVIDER: 'aadhaar',
      AADHAAR_AUA_CODE: 'SMKC',
      AADHAAR_SUB_AUA_CODE: 'SMKC',
      AADHAAR_LICENSE_KEY: 'lk',
      AADHAAR_ASA_LICENSE_KEY: 'asalk',
      AADHAAR_ASA_URL_TEMPLATE: 'https://asa.example/{ver}/{ac}/{uid0}/{uid1}/{asalk}',
      AADHAAR_SIGNING_KEY_PATH: 'keys/aua.key',
      AADHAAR_SIGNING_CERT_PATH: 'keys/aua.crt',
    });
    expect(env.AADHAAR_ENV).toBe('PP');
    expect(() =>
      validateEnv({ ...base, NODE_ENV: 'development', AADHAAR_ASA_URL_TEMPLATE: 'https://asa.example/no-placeholders' }),
    ).toThrow(/must contain/);
  });

  it('runs jobs everywhere but in tests and keeps pings 90 days by default', () => {
    expect(validateEnv({ ...base, NODE_ENV: 'development' }).JOBS_ENABLED).toBe(true);
    expect(validateEnv({ ...base, NODE_ENV: 'test' }).JOBS_ENABLED).toBe(false);
    expect(validateEnv({ ...base, NODE_ENV: 'test', JOBS_ENABLED: 'true' }).JOBS_ENABLED).toBe(true);
    expect(validateEnv({ ...base, NODE_ENV: 'development' }).PING_RETENTION_DAYS).toBe(90);
    expect(() => validateEnv({ ...base, NODE_ENV: 'development', PING_RETENTION_DAYS: '3' })).toThrow(
      /PING_RETENTION_DAYS/,
    );
  });

  it('ignores unrelated environment variables', () => {
    const env = validateEnv({ ...base, NODE_ENV: 'test', PATH: '/usr/bin' }) as unknown as Record<string, unknown>;
    expect(env.PATH).toBeUndefined();
  });
  describe('OTP delivery', () => {
    const prod = {
      ...base,
      NODE_ENV: 'production',
      CORS_ORIGINS: 'https://fieldops.example',
      JWT_ACCESS_SECRET: strongSecret,
      JWT_REFRESH_SECRET: strongSecret,
    };

    it('logs codes in development and is disabled by default in production', () => {
      expect(validateEnv({ ...base, NODE_ENV: 'development' }).OTP_SENDER).toBe('log');
      expect(validateEnv(prod).OTP_SENDER).toBe('disabled');
    });

    it('refuses OTP_SENDER=log in production', () => {
      expect(() => validateEnv({ ...prod, OTP_SENDER: 'log' })).toThrow(/OTP_SENDER=log is not allowed/);
    });

    it('requires a gateway URL with {phone} and {message} for sms_http', () => {
      expect(() => validateEnv({ ...prod, OTP_SENDER: 'sms_http' })).toThrow(/SMS_GATEWAY_URL/);
      expect(() =>
        validateEnv({ ...prod, OTP_SENDER: 'sms_http', SMS_GATEWAY_URL: 'https://sms.example/send?to={phone}' }),
      ).toThrow(/SMS_GATEWAY_URL/);
      const env = validateEnv({
        ...prod,
        OTP_SENDER: 'sms_http',
        SMS_GATEWAY_URL: 'https://sms.example/send?to={phone}&text={message}',
      });
      expect(env.SMS_GATEWAY_URL).toContain('{phone}');
    });

    it('uses high rate limits in test and normal ones elsewhere', () => {
      expect(validateEnv({ ...base, NODE_ENV: 'test' }).SIGN_IN_RATE_LIMIT_PER_MINUTE).toBe(100000);
      expect(validateEnv({ ...base, NODE_ENV: 'development' }).SIGN_IN_RATE_LIMIT_PER_MINUTE).toBe(30);
    });
  });
});
