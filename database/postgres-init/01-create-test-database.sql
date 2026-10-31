-- Runs once when the Postgres container is first created.
-- fieldops_dev is created by POSTGRES_DB; the test suite uses its own database.
CREATE DATABASE fieldops_test;
