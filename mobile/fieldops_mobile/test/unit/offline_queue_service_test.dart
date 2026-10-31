import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fieldops_mobile/core/services/offline_queue_service.dart';

void main() {
  group('OfflineQueueService Tests', () {
    late OfflineQueueService queueService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      queueService = OfflineQueueService();
    });

    test('enqueueCheckIn and getPendingCheckIns works correctly', () async {
      expect(await queueService.hasAnyPending(), isFalse);

      final checkIn = {
        'staff_id': 'staff-123',
        'date': '2026-10-03',
        'checkin_time': '2026-10-03T09:00:00',
        'lat': 16.8524,
        'lng': 74.5815,
      };

      await queueService.enqueueCheckIn(checkIn);
      expect(await queueService.hasAnyPending(), isTrue);

      final pending = await queueService.getPendingCheckIns();
      expect(pending.length, 1);
      expect(pending.first['staff_id'], 'staff-123');

      await queueService.clearCheckInQueue();
      expect(await queueService.hasAnyPending(), isFalse);
    });

    test('enqueueCheckOut and getPendingCheckOuts works correctly', () async {
      final checkOut = {
        'staff_id': 'staff-123',
        'date': '2026-10-03',
        'checkout_time': '2026-10-03T17:00:00',
      };

      await queueService.enqueueCheckOut(checkOut);
      final pending = await queueService.getPendingCheckOuts();
      expect(pending.length, 1);
      expect(pending.first['checkout_time'], '2026-10-03T17:00:00');

      await queueService.clearCheckOutQueue();
      final afterClear = await queueService.getPendingCheckOuts();
      expect(afterClear.isEmpty, isTrue);
    });

    test('enqueuePing caps queue size at 200 items to prevent unbounded memory growth', () async {
      for (int i = 0; i < 210; i++) {
        await queueService.enqueuePing({
          'ping_id': 'ping-$i',
          'lat': 16.85 + (i * 0.0001),
          'lng': 74.58 + (i * 0.0001),
        });
      }

      final pings = await queueService.getPendingPings();
      expect(pings.length, 200);
      // Older items should be dropped, newer kept
      expect(pings.last['ping_id'], 'ping-209');

      await queueService.clearPingQueue();
      expect((await queueService.getPendingPings()).isEmpty, isTrue);
    });
  });
}
