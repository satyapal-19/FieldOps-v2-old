import { channelsFor, pushData, smsText, type Channel } from './notifications.policy';

describe('channelsFor', () => {
  const all = new Set<Channel>(['PUSH', 'SMS', 'WHATSAPP']);
  it.each([
    ['high, everything on', 'HIGH', all, ['PUSH', 'SMS', 'WHATSAPP']],
    ['normal, everything on', 'NORMAL', all, ['PUSH']],
    ['high, nothing configured', 'HIGH', new Set<Channel>(), []],
    ['high, only SMS', 'HIGH', new Set<Channel>(['SMS']), ['SMS']],
    ['normal, only SMS', 'NORMAL', new Set<Channel>(['SMS']), []],
  ] as const)('%s', (_case, priority, enabled, expected) => {
    expect(channelsFor(priority, enabled)).toEqual(expected);
  });
});

describe('pushData', () => {
  it('carries ids and kinds only, never the text', () => {
    const data = pushData('n1', {
      kind: 'SPOT_CHECK',
      priority: 'HIGH',
      title: 'Spot check for Ramesh Patil at Ganpati Peth',
      body: 'Answer within 10 minutes',
      refType: 'SPOT_CHECK',
      refId: 's1',
    });
    expect(data).toEqual({
      notificationId: 'n1',
      kind: 'SPOT_CHECK',
      priority: 'HIGH',
      refType: 'SPOT_CHECK',
      refId: 's1',
    });
    expect(JSON.stringify(data)).not.toContain('Ramesh');
  });
});

describe('smsText', () => {
  it('prefers Marathi and joins title and body', () => {
    expect(
      smsText({
        kind: 'SPOT_CHECK',
        priority: 'HIGH',
        title: 'Spot check',
        titleMr: 'अचानक तपासणी',
        body: 'Open the app',
      }),
    ).toBe('अचानक तपासणी: Open the app');
  });

  it('cuts to one SMS part', () => {
    const text = smsText({ kind: 'ALERT', priority: 'HIGH', title: 'x'.repeat(300) });
    expect([...text]).toHaveLength(160);
    expect(text.endsWith('…')).toBe(true);
  });
});
