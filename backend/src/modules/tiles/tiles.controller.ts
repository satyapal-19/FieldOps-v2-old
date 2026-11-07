import { Controller, Get, Header, Param, ParseIntPipe, StreamableFile } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiProduces, ApiProperty, ApiTags } from '@nestjs/swagger';
import { readFile } from 'node:fs/promises';
import { isAbsolute, join, resolve } from 'node:path';
import { Public } from '../../shared/auth/decorators';
import { AppConfig } from '../../shared/config/app-config';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { tilePath, validTile } from './tiles.policy';

export class TileManifestDto {
  @ApiProperty({
    description: 'False when no offline pack is installed (use the public OSM server)',
  })
  available: boolean;
  @ApiProperty({ nullable: true, type: Number }) minZoom: number | null;
  @ApiProperty({ nullable: true, type: Number }) maxZoom: number | null;
  @ApiProperty({
    nullable: true,
    type: [Number],
    description: '[west, south, east, north] of the pack',
  })
  bounds: number[] | null;
  @ApiProperty({ example: '© OpenStreetMap contributors' }) attribution: string;
  @ApiProperty({ nullable: true, type: String, description: 'When the pack was built' })
  builtAt: string | null;
}

const ATTRIBUTION = '© OpenStreetMap contributors';

/**
 * The offline SMKMC tile pack (action plan Phase 4): OpenStreetMap tiles built for the
 * corporation area and served by our own server, so maps work when public servers are
 * unreachable and no bulk load hits openstreetmap.org. Public, like the map itself; the phone
 * pre-caches the field area from here.
 */
@ApiTags('tiles')
@Controller('tiles')
export class TilesController {
  constructor(private readonly config: AppConfig) {}

  @Public()
  @Get('manifest')
  @ApiOperation({ summary: 'Whether an offline tile pack is installed, and its zooms and bounds' })
  @ApiOkResponse({ type: TileManifestDto })
  async manifest(): Promise<TileManifestDto> {
    const none = {
      available: false,
      minZoom: null,
      maxZoom: null,
      bounds: null,
      attribution: ATTRIBUTION,
      builtAt: null,
    };
    const dir = this.dir();
    if (!dir) return none;
    try {
      const m = JSON.parse(
        await readFile(join(dir, 'manifest.json'), 'utf8'),
      ) as Partial<TileManifestDto>;
      return {
        available: true,
        minZoom: m.minZoom ?? null,
        maxZoom: m.maxZoom ?? null,
        bounds: m.bounds ?? null,
        attribution: m.attribution ?? ATTRIBUTION,
        builtAt: m.builtAt ?? null,
      };
    } catch {
      return none;
    }
  }

  @Public()
  @Get(':z/:x/:y.png')
  @Header('Cache-Control', 'public, max-age=604800')
  @ApiProduces('image/png')
  @ApiOperation({ summary: 'One map tile from the offline pack (404 when not in the pack)' })
  @ApiOkResponse({ schema: { type: 'string', format: 'binary' } })
  async tile(
    @Param('z', ParseIntPipe) z: number,
    @Param('x', ParseIntPipe) x: number,
    @Param('y', ParseIntPipe) y: number,
  ): Promise<StreamableFile> {
    const dir = this.dir();
    if (!dir || !validTile(z, x, y)) throw new AppError(ErrorCode.NOT_FOUND, 'No such tile');
    try {
      const bytes = await readFile(join(dir, tilePath(z, x, y)));
      return new StreamableFile(bytes, { type: 'image/png', length: bytes.length });
    } catch {
      throw new AppError(ErrorCode.NOT_FOUND, 'No such tile');
    }
  }

  private dir(): string | null {
    const dir = this.config.tileDir;
    return dir ? (isAbsolute(dir) ? dir : resolve(process.cwd(), dir)) : null;
  }
}
