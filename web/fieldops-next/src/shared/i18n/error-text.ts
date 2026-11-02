import table from '@/api/generated/error-messages.json';
import type { Lang } from './lang';

const messages = (table as { messages: Record<string, { en: string; mr: string }> }).messages;

/** The message for an API error code in `lang`, falling back to the server's English title. */
export function errorText(code: string, lang: Lang, fallback?: string): string {
  return messages[code]?.[lang] ?? fallback ?? messages.INTERNAL_ERROR[lang];
}
