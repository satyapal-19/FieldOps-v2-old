import { MigrationInterface, QueryRunner, TableCheck } from 'typeorm';

/** Voice notes (chat, Phase 4) go through the same uploads table: widen the kind check. */
export class UploadVoiceNotes1793577600100 implements MigrationInterface {
  name = 'UploadVoiceNotes1793577600100';

  async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropCheckConstraint('uploads', 'ck_uploads_kind');
    await queryRunner.createCheckConstraint(
      'uploads',
      new TableCheck({
        name: 'ck_uploads_kind',
        expression: `"kind" IN ('TASK_PHOTO', 'VOICE_NOTE')`,
      }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropCheckConstraint('uploads', 'ck_uploads_kind');
    await queryRunner.createCheckConstraint(
      'uploads',
      new TableCheck({ name: 'ck_uploads_kind', expression: `"kind" IN ('TASK_PHOTO')` }),
    );
  }
}
