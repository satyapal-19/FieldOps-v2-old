import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for AuthApi
void main() {
  final instance = FieldopsApi().getAuthApi();

  group(AuthApi, () {
    // Change own web password; signs out other devices
    //
    //Future authControllerChangePassword(ChangePasswordDto changePasswordDto) async
    test('test authControllerChangePassword', () async {
      // TODO
    });

    // Web dashboard sign-in (ADMIN, WARD_INSPECTOR, OFFICE_STAFF)
    //
    //Future<SessionTokensDto> authControllerLogin(String userAgent, PasswordLoginDto passwordLoginDto) async
    test('test authControllerLogin', () async {
      // TODO
    });

    // Sign out this device (or every device)
    //
    //Future authControllerLogout(LogoutDto logoutDto) async
    test('test authControllerLogout', () async {
      // TODO
    });

    // The signed-in staff member
    //
    //Future<StaffProfileDto> authControllerMe() async
    test('test authControllerMe', () async {
      // TODO
    });

    // Swap a refresh token for a new pair (rotation; reuse revokes the session)
    //
    //Future<SessionTokensDto> authControllerRefresh(RefreshDto refreshDto) async
    test('test authControllerRefresh', () async {
      // TODO
    });

    // Send a 6-digit sign-in code by SMS (same answer for unknown numbers)
    //
    //Future<OtpRequestedDto> authControllerRequestOtp(OtpRequestDto otpRequestDto) async
    test('test authControllerRequestOtp', () async {
      // TODO
    });

    // Sign a staff member out of every device (ADMIN)
    //
    //Future<RevokedCountDto> authControllerRevokeSessions(String staffId) async
    test('test authControllerRevokeSessions', () async {
      // TODO
    });

    // Development / test only: sign in without OTP. 404 in production.
    //
    //Future<SessionTokensDto> authControllerTestLogin(String userAgent, TestLoginDto testLoginDto) async
    test('test authControllerTestLogin', () async {
      // TODO
    });

    // Exchange the SMS code for tokens
    //
    //Future<SessionTokensDto> authControllerVerifyOtp(String userAgent, OtpVerifyDto otpVerifyDto) async
    test('test authControllerVerifyOtp', () async {
      // TODO
    });

  });
}
