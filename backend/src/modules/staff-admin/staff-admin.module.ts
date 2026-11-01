import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { OfficesModule } from '../offices/offices.module';
import { StaffModule } from '../staff/staff.module';
import { WardsModule } from '../wards/wards.module';
import { StaffAdminController } from './staff-admin.controller';
import { StaffAdminService } from './staff-admin.service';

/**
 * Staff management endpoints (/staff). Separate from StaffModule because it needs AuthService
 * (password hashing, session revocation), and AuthModule already depends on StaffModule.
 * Storage goes through StaffService; this module owns no tables.
 */
@Module({
  imports: [StaffModule, AuthModule, WardsModule, OfficesModule],
  controllers: [StaffAdminController],
  providers: [StaffAdminService],
})
export class StaffAdminModule {}
