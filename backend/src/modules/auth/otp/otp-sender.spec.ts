import { buildOtpText, buildSmsUrl, SmsGatewaySettings } from './otp-sender';

const settings: SmsGatewaySettings = {
  urlTemplate: 'https://sms.example/send?to={phone}&text={message}&from={senderId}&tid={templateId}',
  method: 'GET',
  messageTemplate: 'FieldOps SMKMC login code {otp}. Valid {minutes} min.',
  senderId: 'SMKCGV',
  templateId: '1107',
  timeoutMs: 5000,
};

describe('otp-sender helpers', () => {
  it('fills the message template', () => {
    expect(buildOtpText(settings.messageTemplate, '042917', 5)).toBe('FieldOps SMKMC login code 042917. Valid 5 min.');
  });

  it('builds an encoded gateway URL with the 91 country prefix', () => {
    expect(buildSmsUrl(settings, '9812345678', 'code 1 & 2')).toBe(
      'https://sms.example/send?to=919812345678&text=code%201%20%26%202&from=SMKCGV&tid=1107',
    );
  });
});
