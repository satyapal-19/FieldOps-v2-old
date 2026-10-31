// Loads .env.test (or real env vars in CI) before any test module is imported.
import '../src/shared/config/load-env';
import 'reflect-metadata';

// Config is validated when AppModule is first imported, so test-only switches go here.
// Test login is how suites sign in without SMS (D3); it is refused in production.
process.env.AUTH_TEST_LOGIN_ENABLED = 'true';
