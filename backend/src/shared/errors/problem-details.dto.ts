import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ErrorCode } from './error-codes';

/** Swagger description of the problem+json error body. */
export class ProblemDetailsDto {
  @ApiProperty({ example: 'urn:fieldops:error:NOT_FOUND' })
  type: string;

  @ApiProperty({ enum: ErrorCode, enumName: 'ErrorCode', example: ErrorCode.NOT_FOUND })
  code: ErrorCode;

  @ApiProperty({ example: 'Not found' })
  title: string;

  @ApiProperty({ example: 404 })
  status: number;

  @ApiProperty({ example: '7f3c2a1e-9b4d-4e1a-8c2f-1d5e6a7b8c90' })
  requestId: string;

  @ApiPropertyOptional({ type: 'object', additionalProperties: true })
  details?: Record<string, unknown>;
}
