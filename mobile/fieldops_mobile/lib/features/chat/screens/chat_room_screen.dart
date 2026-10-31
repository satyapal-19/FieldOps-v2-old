import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/controllers/auth_controller.dart';
import '../controllers/chat_controller.dart';

class ChatRoomScreen extends StatefulWidget {
  final String partnerId;
  final String partnerName;
  final bool isBroadcast;

  const ChatRoomScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
    this.isBroadcast = false,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _ctrl      = Get.find<ChatController>();
  final _auth      = Get.find<AuthController>();
  final _msgInput  = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl.messages.listen((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _ctrl.closeRoom();
    _msgInput.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _msgInput.text.trim();
    if (text.isEmpty) return;
    _ctrl.sendMessage(
      content: text,
      receiverId: widget.isBroadcast ? null : widget.partnerId,
      isBroadcast: widget.isBroadcast,
    );
    _msgInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    final myId = _auth.currentStaff.value?['id'] as String? ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.partnerName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          if (widget.isBroadcast)
            const Text('सर्व कर्मचाऱ्यांना',
              style: TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 11, color: Colors.white70)),
        ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(children: [
        // Messages
        Expanded(
          child: Obx(() {
            if (_ctrl.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (_ctrl.messages.isEmpty) {
              return const Center(child: Text('कोणतेही संदेश नाहीत',
                style: TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle)));
            }
            return ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              itemCount: _ctrl.messages.length,
              itemBuilder: (_, i) {
                final msg  = _ctrl.messages[i];
                final isMe = msg['sender_id'] == myId;
                return _MessageBubble(msg: msg, isMe: isMe);
              },
            );
          }),
        ),

        // Input bar
        if (!widget.isBroadcast || _auth.isSupervisor)
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.only(
              left: 12, right: 8, top: 8,
              bottom: MediaQuery.of(context).padding.bottom + 8,
            ),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _msgInput,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: widget.isBroadcast ? 'Broadcast संदेश...' : 'संदेश लिहा...',
                    hintStyle: const TextStyle(fontFamily: 'NotoSansDevanagari', color: AppColors.subtle),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => GestureDetector(
                onTap: _ctrl.isSending.value ? null : _send,
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _ctrl.isSending.value ? AppColors.border : AppColors.primary,
                  ),
                  child: _ctrl.isSending.value
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                ),
              )),
            ]),
          ),
      ]),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> msg;
  final bool isMe;
  const _MessageBubble({required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final sender    = msg['sender'] as Map<String, dynamic>?;
    final senderName = sender?['name_mr'] ?? sender?['name'] ?? '';
    final content   = msg['content'] as String? ?? '';
    final createdAt = msg['created_at'] as String?;
    final isBroadcast = msg['is_broadcast'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                senderName.isNotEmpty ? senderName[0] : '?',
                style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isBroadcast
                    ? Colors.orange.shade50
                    : isMe
                      ? AppColors.primary
                      : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isBroadcast ? Border.all(color: Colors.orange.shade200) : null,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (!isMe && senderName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(senderName,
                      style: TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: isBroadcast ? Colors.orange.shade800 : AppColors.primary,
                      )),
                  ),
                Text(content,
                  style: TextStyle(
                    fontSize: 14,
                    color: isMe ? Colors.white : AppColors.onSurface,
                    height: 1.4,
                  )),
                const SizedBox(height: 4),
                Text(
                  createdAt != null ? _formatTime(createdAt) : '',
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white.withValues(alpha: 0.7) : AppColors.subtle,
                  ),
                ),
              ]),
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
