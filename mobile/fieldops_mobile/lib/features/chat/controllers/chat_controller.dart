import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/controllers/auth_controller.dart';

class ChatController extends GetxController {
  final _supabase = Supabase.instance.client;

  final conversations = <Map<String, dynamic>>[].obs;
  final messages      = <Map<String, dynamic>>[].obs;
  final isLoading     = false.obs;
  final isSending     = false.obs;

  RealtimeChannel? _channel;


  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  @override
  void onClose() {
    _channel?.unsubscribe();
    super.onClose();
  }

  // ── Conversations list ────────────────────────────────────

  Future<void> loadConversations() async {
    isLoading.value = true;
    try {
      final staffId = Get.find<AuthController>().currentStaff.value?['id'];
      if (staffId == null) return;

      // Get all messages where staff is sender or receiver
      final data = await _supabase
          .from('messages')
          .select('*, sender:sender_id(id,name,name_mr,profile_photo_url,role), receiver:receiver_id(id,name,name_mr,profile_photo_url,role)')
          .or('sender_id.eq.$staffId,receiver_id.eq.$staffId')
          .eq('is_broadcast', false)
          .order('created_at', ascending: false)
          .limit(100);

      // Group by conversation partner
      final Map<String, Map<String, dynamic>> convMap = {};
      for (final msg in data as List) {
        final isMe = msg['sender_id'] == staffId;
        final partnerId = (isMe ? msg['receiver_id'] : msg['sender_id']) as String?;
        if (partnerId == null) continue;
        final partnerInfo = isMe ? msg['receiver'] : msg['sender'];
        if (!convMap.containsKey(partnerId)) {
          convMap[partnerId] = {
            'partner_id':   partnerId,
            'partner':      partnerInfo,
            'last_message': msg['content'],
            'last_at':      msg['created_at'],
            'unread':       (!isMe && msg['read_at'] == null) ? 1 : 0,
          };
        } else if (!isMe && msg['read_at'] == null) {
          convMap[partnerId]!['unread'] =
              (convMap[partnerId]!['unread'] as int) + 1;
        }
      }

      // Add broadcasts
      final broadcasts = await _supabase
          .from('messages')
          .select('*, sender:sender_id(id,name,name_mr,profile_photo_url,role)')
          .eq('is_broadcast', true)
          .order('created_at', ascending: false)
          .limit(5);

      if ((broadcasts as List).isNotEmpty) {
        convMap['broadcast'] = {
          'partner_id':   'broadcast',
          'is_broadcast': true,
          'last_message': broadcasts.first['content'],
          'last_at':      broadcasts.first['created_at'],
          'unread':       0,
        };
      }

      // Ensure supervisors are in contacts list
      try {
        final supervisors = await _supabase
            .from('staff')
            .select('id, name, name_mr, profile_photo_url, role, designation')
            .inFilter('role', ['SUPERVISOR', 'ADMIN'])
            .neq('id', staffId)
            .limit(5);

        for (final sup in supervisors as List) {
          final supId = sup['id'] as String;
          if (!convMap.containsKey(supId)) {
            convMap[supId] = {
              'partner_id':   supId,
              'partner':      sup,
              'last_message': 'संदेश पाठवण्यासाठी टॅप करा (${sup['designation'] ?? sup['role']})',
              'last_at':      DateTime.now().toIso8601String(),
              'unread':       0,
            };
          }
        }
      } catch (e) {
        debugPrint('Supervisor contacts lookup: $e');
      }

      conversations.value = convMap.values.toList()
        ..sort((a, b) => (b['last_at'] as String)
            .compareTo(a['last_at'] as String));
    } catch (e) {
      debugPrint('Load conversations error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Messages in a room ────────────────────────────────────

  Future<void> openRoom(String partnerId) async {
    messages.clear();
    isLoading.value = true;


    try {
      final staffId = Get.find<AuthController>().currentStaff.value?['id'];
      if (staffId == null) return;

      final List<dynamic> data;
      if (partnerId == 'broadcast') {
        data = await _supabase
            .from('messages')
            .select('*, sender:sender_id(id,name,name_mr,profile_photo_url)')
            .eq('is_broadcast', true)
            .order('created_at');
      } else {
        data = await _supabase
            .from('messages')
            .select('*, sender:sender_id(id,name,name_mr,profile_photo_url)')
            .or('and(sender_id.eq.$staffId,receiver_id.eq.$partnerId),and(sender_id.eq.$partnerId,receiver_id.eq.$staffId)')
            .order('created_at');
      }

      messages.value = List<Map<String, dynamic>>.from(data);

      // Mark received messages as read
      await _supabase
          .from('messages')
          .update({'read_at': DateTime.now().toIso8601String()})
          .eq('receiver_id', staffId)
          .eq('sender_id', partnerId)
          .isFilter('read_at', null);

      // Subscribe to realtime
      _subscribeToRoom(staffId, partnerId);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void _subscribeToRoom(String myId, String partnerId) {
    _channel?.unsubscribe();
    _channel = _supabase
        .channel('messages-$myId-$partnerId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final newMsg = payload.newRecord;
            if (_isForThisRoom(newMsg, myId, partnerId)) {
              messages.add(newMsg);
            }
          },
        )
        .subscribe();
  }

  bool _isForThisRoom(
    Map<String, dynamic> msg,
    String myId,
    String partnerId,
  ) {
    if (partnerId == 'broadcast') return msg['is_broadcast'] == true;
    final sid = msg['sender_id'];
    final rid = msg['receiver_id'];
    return (sid == myId && rid == partnerId) ||
           (sid == partnerId && rid == myId);
  }

  // ── Send message ──────────────────────────────────────────

  Future<void> sendMessage({
    required String content,
    String? receiverId,
    bool isBroadcast = false,
    String? voiceUrl,
  }) async {
    if (content.trim().isEmpty && voiceUrl == null) return;
    isSending.value = true;
    try {
      final staffId = Get.find<AuthController>().currentStaff.value?['id'];
      if (staffId == null) return;
      final inserted = await _supabase.from('messages').insert({
        'sender_id':    staffId,
        'receiver_id':  isBroadcast ? null : receiverId,
        'content':      content.trim(),
        'is_broadcast': isBroadcast,
        'voice_url':    voiceUrl,
        'created_at':   DateTime.now().toIso8601String(),
      }).select('*, sender:sender_id(id,name,name_mr,profile_photo_url)').single();
      if (!messages.any((m) => m['id'] == inserted['id'])) {
        messages.add(inserted);
      }
    } catch (e) {
      debugPrint('Send message error: $e');
    } finally {
      isSending.value = false;
    }
  }

  void closeRoom() {
    _channel?.unsubscribe();
    _channel = null;
    messages.clear();
  }
}

