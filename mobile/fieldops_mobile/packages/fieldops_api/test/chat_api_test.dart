import 'package:test/test.dart';
import 'package:fieldops_api/fieldops_api.dart';


/// tests for ChatApi
void main() {
  final instance = FieldopsApi().getChatApi();

  group(ChatApi, () {
    // Open (or reuse) a direct conversation along the hierarchy
    //
    //Future<ConversationDto> chatControllerDirect(DirectDto directDto) async
    test('test chatControllerDirect', () async {
      // TODO
    });

    // My conversations (joins today's squad / ward channels), newest first
    //
    //Future<BuiltList<ConversationDto>> chatControllerList() async
    test('test chatControllerList', () async {
      // TODO
    });

    // A message's voice note or photo, for the conversation's members
    //
    //Future<Uint8List> chatControllerMedia(String id) async
    test('test chatControllerMedia', () async {
      // TODO
    });

    // Messages, newest first (page back with before)
    //
    //Future<BuiltList<MessageDto>> chatControllerMessages(String id, { DateTime before, int limit }) async
    test('test chatControllerMessages', () async {
      // TODO
    });

    // Mark the conversation read up to now
    //
    //Future chatControllerRead(String id) async
    test('test chatControllerRead', () async {
      // TODO
    });

    // Send a text, voice note, photo or location (retry-safe with clientUuid)
    //
    //Future<MessageDto> chatControllerSend(String id, SendMessageDto sendMessageDto) async
    test('test chatControllerSend', () async {
      // TODO
    });

  });
}
