import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' show MultipartFile;
import 'package:fieldops_api/fieldops_api.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../api/api_failure.dart';
import '../api/api_service.dart';
import 'outbox.dart';
import 'sqlite_outbox_store.dart';

/// Every offline-capable write goes through here: pings, tamper events and
/// task updates are stored first, then sent when the network allows.
class OutboxService extends GetxService {
  final OutboxStore store;
  late final Outbox outbox;

  /// Items still waiting to be sent (shown on the home screen).
  final pending = 0.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  Timer? _timer;

  OutboxService(this.store) {
    outbox = Outbox(store: store, sender: _send);
  }

  static Future<OutboxService> open() async =>
      OutboxService(await SqliteOutboxStore.open());

  ApiService get _api => Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    _connectivity = Connectivity().onConnectivityChanged.listen((results) {
      if (!results.every((r) => r == ConnectivityResult.none)) flush();
    });
    // Backoff is per row; this only wakes the outbox to look.
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => flush());
    _refreshCount();
  }

  @override
  void onClose() {
    _connectivity?.cancel();
    _timer?.cancel();
    super.onClose();
  }

  Future<void> addPing(PingDto ping) => _add(
        OutboxKind.ping,
        ping.clientUuid,
        _api.encode(PingDto.serializer, ping),
      );

  Future<void> addTamper(TamperEventDto event) => _add(
        OutboxKind.tamper,
        event.clientUuid,
        _api.encode(TamperEventDto.serializer, event),
      );

  /// A task START / SUBMIT. With [photoPath] (a file the outbox owns), the
  /// photo is uploaded first under its own client UUID and its ID becomes
  /// the update's `photoKey`; a retried upload returns the same ID.
  Future<void> addTaskUpdate(String taskId, AssigneeUpdateDto update, {String? photoPath}) => _add(
        OutboxKind.taskUpdate,
        update.clientUuid,
        jsonEncode({
          'update': jsonDecode(_api.encode(AssigneeUpdateDto.serializer, update)),
          if (photoPath != null) 'photoPath': photoPath,
          if (photoPath != null) 'uploadUuid': const Uuid().v4(),
        }),
        ref: taskId,
      );

  /// Where task photos wait until they are uploaded.
  static Future<Directory> photoDir() async {
    final dir = Directory(p.join((await getApplicationSupportDirectory()).path, 'outbox_photos'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<void> _sendTaskUpdate(OutboxItem item) async {
    final body = jsonDecode(item.payload) as Map<String, dynamic>;
    var update = _api.client.serializers
        .deserializeWith(AssigneeUpdateDto.serializer, body['update']) as AssigneeUpdateDto;
    final photoPath = body['photoPath'] as String?;
    File? photo;
    if (photoPath != null) {
      photo = File(photoPath);
      if (await photo.exists()) {
        final upload = await _api.uploads.uploadsControllerUpload(
          file: await MultipartFile.fromFile(photoPath, filename: p.basename(photoPath)),
          clientUuid: body['uploadUuid'] as String,
          kind: 'TASK_PHOTO',
        );
        update = update.rebuild((b) => b..photoKey = upload.data!.id);
      }
    }
    await _api.tasks.tasksControllerAssigneeUpdate(id: item.ref!, assigneeUpdateDto: update);
    if (photo != null && await photo.exists()) await photo.delete();
  }

  Future<void> _add(OutboxKind kind, String uuid, String payload, {String? ref}) async {
    await outbox.enqueue(kind, uuid, payload, ref: ref);
    await _refreshCount();
    unawaited(flush());
  }

  Future<int> flush() async {
    if (!await _api.session.hasSession) return 0;
    try {
      return await outbox.flush();
    } finally {
      await _refreshCount();
    }
  }

  Future<void> _refreshCount() async => pending.value = await store.count();

  T _decode<T>(Serializer<T> s, String raw) =>
      _api.client.serializers.deserializeWith(s, jsonDecode(raw)) as T;

  Future<SendOutcome> _send(OutboxKind kind, List<OutboxItem> items) async {
    try {
      switch (kind) {
        case OutboxKind.ping:
          final res = await _api.attendance.attendanceControllerPings(
            pingBatchDto: PingBatchDto((b) => b
              ..pings = ListBuilder(items.map((i) => _decode(PingDto.serializer, i.payload)
                  .rebuild((p) => p..fromOffline = _wasBuffered(i))))),
          );
          return _batchOutcome(items, res.data!.rejected);
        case OutboxKind.tamper:
          final res = await _api.attendance.attendanceControllerTamper(
            tamperBatchDto: TamperBatchDto((b) => b
              ..events = ListBuilder(items.map((i) => _decode(TamperEventDto.serializer, i.payload)))),
          );
          return _batchOutcome(items, res.data!.rejected);
        case OutboxKind.taskUpdate:
          final item = items.single;
          await _sendTaskUpdate(item);
          return SendOutcome(done: {item.clientUuid});
      }
    } catch (e) {
      final f = ApiFailure.from(e);
      // Signed out or a server / network problem: keep the data and retry.
      if (f.isRetryable || f.status == 401 || f.status == null) {
        throw RetryLater(f.code);
      }
      // Refused for good (validation, task closed, not allowed): drop the
      // rows so one bad item never blocks the queue.
      debugPrint('Outbox ${kind.name} refused: $f');
      return SendOutcome(rejected: {for (final i in items) i.clientUuid: f.code});
    }
  }

  /// Sent late (failed before, or recorded while offline).
  static bool _wasBuffered(OutboxItem i) =>
      i.attempts > 0 ||
      DateTime.now().toUtc().difference(i.createdAt) > const Duration(minutes: 2);

  SendOutcome _batchOutcome(List<OutboxItem> items, BuiltList<RejectedItemDto> rejected) {
    final refused = {for (final r in rejected) r.clientUuid: r.reason};
    return SendOutcome(
      done: items.map((i) => i.clientUuid).where((u) => !refused.containsKey(u)).toSet(),
      rejected: refused,
    );
  }
}
