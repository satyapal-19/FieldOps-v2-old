import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for NotificationsApi
void main() {
  final instance = FieldopsApi().getNotificationsApi();

  group(NotificationsApi, () {
    // My inbox, newest first, with the unread count (the app polls this)
    //
    //Future<InboxDto> notificationsControllerInbox({ bool unreadOnly, DateTime before, int limit }) async
    test('test notificationsControllerInbox', () async {
      // TODO
    });

    // Mark some or all of my messages read
    //
    //Future<MarkedDto> notificationsControllerMarkRead(MarkReadDto markReadDto) async
    test('test notificationsControllerMarkRead', () async {
      // TODO
    });

    // Register this phone's FCM token for my pushes (after sign-in)
    //
    //Future notificationsControllerRegister(PushTokenDto pushTokenDto) async
    test('test notificationsControllerRegister', () async {
      // TODO
    });

    // Stop pushes to this phone (before sign-out)
    //
    //Future notificationsControllerRemove(RemovePushTokenDto removePushTokenDto) async
    test('test notificationsControllerRemove', () async {
      // TODO
    });

  });
}
