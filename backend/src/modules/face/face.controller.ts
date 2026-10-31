import { Controller, Get, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiOperation, ApiProperty, ApiPropertyOptional, ApiTags } from '@nestjs/swagger';
import { IsOptional, IsString, Length } from 'class-validator';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser } from '../../shared/auth/decorators';
import { outranks, Role } from '../../shared/auth/roles';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { FaceVerifier } from './face-verifier';

export class CaptureOptionsQueryDto {
  @ApiPropertyOptional({ description: 'Who is being verified; defaults to the caller. Others only for inspectors and above (proxy marking).' })
  @IsOptional()
  @IsString()
  @Length(1, 64)
  staffId?: string;
}

export class FaceCaptureOptionsDto {
  @ApiProperty({ enum: ['local', 'aadhaar'] }) provider: 'local' | 'aadhaar';
  @ApiProperty({ enum: ['ML_KIT_LIVENESS_THEN_UPLOAD_CROP', 'LAUNCH_FACERD'] }) instructions: string;
  @ApiPropertyOptional({ description: 'Aadhaar only: transaction ID to echo back' }) txn?: string;
  @ApiPropertyOptional({ description: 'Aadhaar only: PidOptions XML for the FaceRD intent extra "request"' })
  pidOptionsXml?: string;
  @ApiPropertyOptional({ example: 'in.gov.uidai.rdservice.face.CAPTURE' }) intentAction?: string;
}

/**
 * Tells the app which capture flow to run. This is the switch that makes Aadhaar
 * plug-and-play on the phone: the app follows `instructions` and never hard-codes a provider.
 */
@ApiTags('face')
@ApiBearerAuth()
@Controller('face')
export class FaceController {
  constructor(private readonly face: FaceVerifier) {}

  @Get('capture-options')
  @ApiOperation({ summary: 'Which face capture flow the app should run (local or Aadhaar FaceRD)' })
  @ApiOkResponse({ type: FaceCaptureOptionsDto })
  captureOptions(
    @CurrentUser() user: AuthUser,
    @Query() query: CaptureOptionsQueryDto,
  ): Promise<FaceCaptureOptionsDto> {
    const staffId = query.staffId ?? user.staffId;
    // Coarse check here; the full team / same-ward rule is enforced when attendance is marked.
    if (staffId !== user.staffId && !outranks(user.role, Role.WORKER)) {
      throw new AppError(ErrorCode.FORBIDDEN);
    }
    return this.face.captureOptions(staffId);
  }
}
