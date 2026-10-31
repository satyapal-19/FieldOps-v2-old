import { ApiProperty } from '@nestjs/swagger';
import { STAFF_ROLES, StaffRole } from '../../../shared/auth/roles';

/** A staff member as the API shows them. Never includes the password hash. */
export class StaffProfileDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ example: 'SMK-W-0042' }) employeeCode: string;
  @ApiProperty({ example: 'Sunil Patil' }) fullName: string;
  @ApiProperty({ example: 'सुनील पाटील', nullable: true, type: String }) fullNameMr: string | null;
  @ApiProperty({ example: '******5678', description: 'Masked except for admins' }) phone: string;
  @ApiProperty({ enum: STAFF_ROLES }) role: StaffRole;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) homeWardId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) officeId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) reportsToId: string | null;
  @ApiProperty({ nullable: true, type: String }) department: string | null;
  @ApiProperty({ example: '06:00' }) shiftStart: string;
  @ApiProperty({ example: '14:00' }) shiftEnd: string;
  @ApiProperty() isActive: boolean;
  @ApiProperty() hasPassword: boolean;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
  @ApiProperty({ format: 'date-time' }) updatedAt: string;
}
