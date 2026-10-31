import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChatController());
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('संदेश'),
        actions: [
          // Broadcast button (supervisors only)
          Obx(() => auth.isSupervisor
            ? IconButton(
                icon: const Icon(Icons.campaign_outlined, color: Colors.white),
                tooltip: 'Broadcast',
                onPressed: () => _showBroadcastDialog(context, ctrl),
              )
            : const SizedBox.shrink()),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: ctrl.loadConversations,
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (ctrl.conversations.isEmpty) {
          return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.border),
            SizedBox(height: 12),
            Text('कोणतेही संदेश नाहीत', style: TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle)),
          ]));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: ctrl.conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (_, i) => _ConvTile(conv: ctrl.conversations[i], ctrl: ctrl),
        );
      }),
    );
  }

  void _showBroadcastDialog(BuildContext context, ChatController ctrl) {
    final msgCtrl = TextEditingController();
    Get.dialog(AlertDialog(
      title: const Text('Broadcast संदेश'),
      content: TextField(
        controller: msgCtrl,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'सर्व कर्मचाऱ्यांना संदेश...',
          hintStyle: TextStyle(fontFamily: 'NotoSansDevanagari'),
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('रद्द करा')),
        FilledButton(
          onPressed: () {
            ctrl.sendMessage(content: msgCtrl.text, isBroadcast: true);
            Get.back();
          },
          child: const Text('पाठवा'),
        ),
      ],
    ));
  }
}

class _ConvTile extends StatelessWidget {
  final Map<String, dynamic> conv;
  final ChatController ctrl;
  const _ConvTile({required this.conv, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isBroadcast = conv['is_broadcast'] == true;
    final partner     = conv['partner'] as Map<String, dynamic>?;
    final name        = partner?['name_mr'] ?? partner?['name'] ?? 'Unknown';
    final unread      = conv['unread'] as int? ?? 0;
    final lastMsg     = conv['last_message'] as String? ?? '';
    final lastAt      = conv['last_at'] as String?;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ctrl.openRoom(conv['partner_id'] ?? 'broadcast');
          Get.to(() => ChatRoomScreen(
            partnerId:   conv['partner_id'] ?? 'broadcast',
            partnerName: isBroadcast ? 'Broadcast 📢' : name,
            isBroadcast: isBroadcast,
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            // Avatar
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isBroadcast
                    ? Colors.orange.withValues(alpha: 0.15)
                    : AppColors.primarySurface,
              ),
              child: Center(child: isBroadcast
                ? const Icon(Icons.campaign, color: Colors.orange, size: 24)
                : Text(
                    (name.isNotEmpty ? name[0] : '?').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
              ),
            ),
            const SizedBox(width: 12),
            // Name + preview
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(
                    isBroadcast ? 'Broadcast 📢' : name,
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  )),
                  if (lastAt != null)
                    Text(_formatTime(lastAt),
                      style: const TextStyle(fontSize: 11, color: AppColors.subtle)),
                ]),
                const SizedBox(height: 3),
                Text(lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: unread > 0 ? AppColors.onSurface : AppColors.subtle,
                    fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                  )),
              ],
            )),
            if (unread > 0) ...[
              const SizedBox(width: 8),
              Container(
                width: 20, height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.primary),
                child: Center(child: Text(
                  '$unread',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                )),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  String _formatTime(String iso) {
    final dt   = DateTime.tryParse(iso);
    if (dt == null) return '';
    final now  = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m';
    if (diff.inHours < 24)    return '${diff.inHours}h';
    return '${dt.day}/${dt.month}';
  }
}
