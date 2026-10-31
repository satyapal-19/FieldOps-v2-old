import { CreateWards1793145600000 } from './1793145600000-create-wards';
import { CreateOfficesAndStaff1793232000000 } from './1793232000000-create-offices-and-staff';
import { CreateAuthAndAudit1793232000100 } from './1793232000100-create-auth-and-audit';

/** Every migration, oldest first. Add new migrations at the end. */
export const MIGRATIONS = [CreateWards1793145600000, CreateOfficesAndStaff1793232000000, CreateAuthAndAudit1793232000100];
