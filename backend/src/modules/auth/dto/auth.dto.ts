import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';
import { StaffProfileDto } from '../../staff/dto/staff-profile.dto';

export class OtpRequestDto {
  @ApiProperty({ example: '9812345678', description: '10-digit mobile; +91 / 0 prefixes are accepted' })
  @IsString()
  @Length(10, 16)
  phone: string;
}

export class OtpRequestedDto {
  @ApiProperty({ description: 'Always true, whether or not the number is registered' }) sent: boolean;
  @ApiProperty({ example: 300 }) expiresInSeconds: number;
}

class DeviceFields {
  @ApiPropertyOptional({ description: 'App install ID (device binding comes after delivery, D3)' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  deviceId?: string;
}

export class OtpVerifyDto extends DeviceFields {
  @ApiProperty({ example: '9812345678' })
  @IsString()
  @Length(10, 16)
  phone: string;

  @ApiProperty({ example: '042917' })
  @Matches(/^\d{6}$/, { message: 'code must be 6 digits' })
  code: string;
}

export class PasswordLoginDto extends DeviceFields {
  @ApiProperty({ example: 'SMK-A-0001', description: 'Employee code or mobile number' })
  @IsString()
  @Length(2, 20)
  identifier: string;

  @ApiProperty({ example: 'correct horse 42' })
  @IsString()
  @Length(1, 200)
  password: string;
}

export class TestLoginDto extends DeviceFields {
  @ApiProperty({ example: 'SMK-W-0001', description: 'Employee code or mobile number' })
  @IsString()
  @Length(2, 20)
  identifier: string;
}

export class RefreshDto {
  @ApiProperty()
  @IsString()
  @Length(40, 120)
  refreshToken: string;
}

export class LogoutDto {
  @ApiPropertyOptional({ default: false, description: 'Sign out of every device' })
  @IsOptional()
  @IsBoolean()
  everywhere?: boolean;
}

export class ChangePasswordDto {
  @ApiProperty() @IsString() @Length(1, 200) currentPassword: string;
  @ApiProperty({ description: '10+ characters with letters and digits' })
  @IsString()
  @Length(10, 72)
  newPassword: string;
}

export class SessionTokensDto {
  @ApiProperty() accessToken: string;
  @ApiProperty({ example: 'Bearer' }) tokenType: 'Bearer';
  @ApiProperty({ example: 900 }) expiresInSeconds: number;
  @ApiProperty({ description: 'Single use: each refresh returns a new one' }) refreshToken: string;
  @ApiProperty({ format: 'date-time' }) refreshExpiresAt: string;
  @ApiProperty({ type: StaffProfileDto }) staff: StaffProfileDto;
}

export class RevokedCountDto {
  @ApiProperty() revoked: number;
}
