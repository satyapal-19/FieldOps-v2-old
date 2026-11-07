import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags, ApiTooManyRequestsResponse } from '@nestjs/swagger';
import { Public } from '../../shared/auth/decorators';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { SignInRateLimit } from '../auth/rate-limit';
import { PublicWardDto } from './dto/ward.dto';
import { WardsService } from './wards.service';

/** Citizens' ward list for the public portal: no sign-in, stricter per-IP limit. */
@ApiTags('public')
@Controller('public/wards')
export class PublicWardsController {
  constructor(private readonly wards: WardsService) {}

  @Public()
  @SignInRateLimit()
  @Get()
  @ApiOperation({ summary: 'Active wards with their boundaries (no sign-in)' })
  @ApiOkResponse({ type: [PublicWardDto] })
  @ApiTooManyRequestsResponse({ type: ProblemDetailsDto })
  async list(): Promise<PublicWardDto[]> {
    const page = await this.wards.list(1, 100);
    return page.items
      .filter((w) => w.isActive)
      .map(({ id, code, name, nameMr, zone, boundary }) => ({
        id,
        code,
        name,
        nameMr,
        zone,
        boundary,
      }));
  }
}
