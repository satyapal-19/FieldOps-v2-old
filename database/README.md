# database/

- `postgres-init/` scripts the local Postgres container runs on first start (creates `fieldops_test`).
- The schema itself lives in **backend migrations** (`backend/src/database/migrations/`), written
  with portable TypeORM column helpers so the same migrations run on PostgreSQL and Oracle 12c.
- Exported DDL for PostgreSQL and Oracle (deliverable 06) and the ER diagram (deliverable 08) are
  generated into this folder in Phase 5.
- `../data/schema.sql` and `../data/seed.sql` are the **legacy Supabase** schema. They are kept for
  reference until the migration is complete and must not be run against the new backend.
