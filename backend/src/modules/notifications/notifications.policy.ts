/**
 * Rules for notifications as pure functions: which channels carry a message, what a push
 * payload may contain (no personal data leaves for Google's servers), and the SMS text.
 */
import type { NotificationKind, NotificationPriority } from './entities/notification.entity';

export type Channel = 'PUSH' | 'SMS' | 'WHATSAPP';

export interface OutgoingMessage {
  kind: NotificationKind;
  priority: NotificationPriority;
  title: string;
  titleMr?: string | null;
  body?: string | null;
  bodyMr?: string | null;
  refType?: string | null;
  refId?: string | null;
}

/**
 * Push for everything (when FCM is configured). SMS / WhatsApp, which cost money and reach
 * the phone even without data, only for HIGH priority: spot checks and urgent escalations.
 */
export function channelsFor(
  priority: NotificationPriority,
  enabled: ReadonlySet<Channel>,
): Channel[] {
  const wanted: Channel[] = priority === 'HIGH' ? ['PUSH', 'SMS', 'WHATSAPP'] : ['PUSH'];
  return wanted.filter((c) => enabled.has(c));
}

/**
 * The FCM data payload: only what the app needs to open the right screen. Titles and bodies
 * (which may name people or places) stay in our inbox; the app fetches them over our API.
 */
export function pushData(notificationId: string, m: OutgoingMessage): Record<string, string> {
  return {
    notificationId,
    kind: m.kind,
    priority: m.priority,
    ...(m.refType ? { refType: m.refType } : {}),
    ...(m.refId ? { refId: m.refId } : {}),
  };
}

/** One SMS: Marathi first when there is Marathi text, cut to a single 160-character part. */
export function smsText(m: OutgoingMessage, max = 160): string {
  const text = [m.titleMr || m.title, m.bodyMr || m.body].filter(Boolean).join(': ');
  return [...text].length <= max ? text : `${[...text].slice(0, max - 1).join('')}…`;
}
