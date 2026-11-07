import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { LessThan, Repository } from 'typeorm';
import { Upload } from './entities/upload.entity';

/** The only place that queries uploads. */
@Injectable()
export class UploadsRepository {
  constructor(@InjectRepository(Upload) private readonly uploads: Repository<Upload>) {}

  findById(id: string): Promise<Upload | null> {
    return this.uploads.findOne({ where: { id } });
  }

  findByClientUuid(clientUuid: string): Promise<Upload | null> {
    return this.uploads.findOne({ where: { clientUuid } });
  }

  /** The oldest uploads of a kind created before `cutoff` (the retention job works in batches). */
  findOlder(kind: Upload['kind'], cutoff: Date, take: number): Promise<Upload[]> {
    return this.uploads.find({
      where: { kind, createdAt: LessThan(cutoff) },
      order: { createdAt: 'ASC' },
      take,
    });
  }

  async delete(id: string): Promise<void> {
    await this.uploads.delete({ id });
  }

  async insert(row: Upload): Promise<void> {
    await this.uploads.insert(row);
  }
}
