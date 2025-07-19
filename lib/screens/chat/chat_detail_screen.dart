import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isRecording = false;
  bool _hasText = false;

  // Mock messages data
  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
    _messageController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _messageController.text.trim().isNotEmpty;
    });
  }

  void _initializeMessages() {
    // Initialize with different message types based on chat type
    if (widget.chat['type'] == 'emergency') {
      _messages = [
        {
          'id': 'msg_001',
          'type': 'emergency',
          'content': 'URGENT: Equipment failure at Downtown Office Building. HVAC system completely down. Customer requesting immediate response!',
          'sender': 'Dispatch Center',
          'senderAvatar': 'DC',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
          'isRead': true,
          'priority': 'critical',
          'jobId': 'JOB003',
          'location': {'lat': 40.7128, 'lng': -74.0060, 'address': '123 Downtown St, New York, NY'},
          'reactions': {'👍': 2, '✅': 1},
        },
        {
          'id': 'msg_002',
          'type': 'text',
          'content': 'I\'m 10 minutes away from the location. ETA 2:15 PM.',
          'sender': 'Mike Johnson',
          'senderAvatar': 'MJ',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
          'isRead': true,
          'replyTo': 'msg_001',
        },
        {
          'id': 'msg_003',
          'type': 'text',
          'content': 'Perfect! I\'ll notify the client. Emergency response team is on standby.',
          'sender': 'Sam Rodriguez',
          'senderAvatar': 'SR',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
          'isRead': false,
        },
      ];
    } else {
      _messages = [
        {
          'id': 'msg_001',
          'type': 'text',
          'content': 'Hey team! Just finished the quarterly pest control at Green Valley Restaurant. Everything went smoothly.',
          'sender': 'Mike Johnson',
          'senderAvatar': 'MJ',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isRead': true,
          'reactions': {'👍': 2, '🎉': 1},
        },
        {
          'id': 'msg_002',
          'type': 'image',
          'content': 'Before and after photos of the treatment area',
          'sender': 'Mike Johnson',
          'senderAvatar': 'MJ',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isRead': true,
          'images': [
            'https://example.com/before.jpg',
            'https://example.com/after.jpg',
          ],
        },
        {
          'id': 'msg_003',
          'type': 'file',
          'content': 'Treatment report and recommendations',
          'sender': 'Mike Johnson',
          'senderAvatar': 'MJ',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
          'isRead': true,
          'fileName': 'GreenValley_PestControl_Report.pdf',
          'fileSize': '2.4 MB',
          'fileIcon': Icons.picture_as_pdf,
        },
        {
          'id': 'msg_004',
          'type': 'location',
          'content': 'Current location - heading to next job site',
          'sender': 'Mike Johnson',
          'senderAvatar': 'MJ',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          'isRead': true,
          'location': {'lat': 40.7829, 'lng': -73.9654, 'address': '456 Service Ave, New York, NY'},
        },
        {
          'id': 'msg_005',
          'type': 'job_reference',
          'content': 'Updated job status to completed',
          'sender': 'System',
          'senderAvatar': '🤖',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'isRead': true,
          'jobId': 'JOB001',
          'jobTitle': 'Quarterly Pest Control - Green Valley Restaurant',
          'jobStatus': 'completed',
        },
        {
          'id': 'msg_006',
          'type': 'voice',
          'content': 'Voice message about inventory needs',
          'sender': 'Alex Chen',
          'senderAvatar': 'AC',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
          'isRead': true,
          'duration': '0:45',
          'isPlaying': false,
        },
        {
          'id': 'msg_007',
          'type': 'text',
          'content': 'Great work on the Green Valley job! Don\'t forget we need to restock the pest control supplies.',
          'sender': 'Alex Chen',
          'senderAvatar': 'AC',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
          'isRead': false,
          'replyTo': 'msg_005',
        },
      ];
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmergency = widget.chat['type'] == 'emergency';
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isEmergency ? Colors.red[50] : null,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isEmergency ? Colors.red : const Color(0xFF14B8A6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: widget.chat['avatar'] != null
                    ? Text(
                        widget.chat['avatar'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(
                        isEmergency ? Icons.emergency : Icons.group,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isEmergency ? Colors.red[800] : null,
                    ),
                  ),
                  if (widget.chat['participants'] != null)
                    Text(
                      '${widget.chat['participants'].length} participants',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: _makeVoiceCall,
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: _makeVideoCall,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'info', child: Text('Chat Info')),
              const PopupMenuItem(value: 'mute', child: Text('Mute Notifications')),
              const PopupMenuItem(value: 'search', child: Text('Search Messages')),
              if (isEmergency) const PopupMenuItem(value: 'resolve', child: Text('Resolve Emergency')),
              const PopupMenuItem(value: 'export', child: Text('Export Chat')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Emergency Banner
          if (isEmergency)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red[100],
              child: Row(
                children: [
                  const Icon(Icons.emergency, color: Colors.red),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'EMERGENCY CHAT - All messages are high priority',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _resolveEmergency,
                    child: const Text('Resolve'),
                  ),
                ],
              ),
            ),
          
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'Sam Rodriguez';
                return _buildMessage(message, isMe);
              },
            ),
          ),
          
          // Typing Indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.more_horiz, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Someone is typing...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  message['senderAvatar'] ?? '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      message['sender'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                _buildMessageContent(message, isMe),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message['timestamp']),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    if (isMe && message['isRead']) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all,
                        size: 14,
                        color: Color(0xFF14B8A6),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'SR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> message, bool isMe) {
    switch (message['type']) {
      case 'text':
        return _buildTextMessage(message, isMe);
      case 'emergency':
        return _buildEmergencyMessage(message, isMe);
      case 'image':
        return _buildImageMessage(message, isMe);
      case 'file':
        return _buildFileMessage(message, isMe);
      case 'location':
        return _buildLocationMessage(message, isMe);
      case 'voice':
        return _buildVoiceMessage(message, isMe);
      case 'job_reference':
        return _buildJobReferenceMessage(message, isMe);
      default:
        return _buildTextMessage(message, isMe);
    }
  }

  Widget _buildTextMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF14B8A6) : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message['replyTo'] != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: (isMe ? Colors.white : Colors.grey[200])?.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (isMe ? Colors.white : Colors.grey)?.withOpacity(0.5) ?? Colors.transparent,
                ),
              ),
              child: Text(
                'Replying to: ${_getReplyContent(message['replyTo'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: isMe ? Colors.white70 : Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          Text(
            message['content'],
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 14,
            ),
          ),
          if (message['reactions'] != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: message['reactions'].entries.map<Widget>((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${entry.key} ${entry.value}',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmergencyMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emergency, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'EMERGENCY ALERT',
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message['content'],
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (message['jobId'] != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.work, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Job: ${message['jobId']}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
          if (message['location'] != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message['location']['address'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openLocation(message['location']),
                    child: const Text('Navigate', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF14B8A6) : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message['content'].isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                message['content'],
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: message['images'].map<Widget>((imageUrl) {
              return Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFileMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF14B8A6) : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isMe ? Colors.white : Colors.grey[300])?.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              message['fileIcon'] ?? Icons.insert_drive_file,
              color: isMe ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['fileName'] ?? 'File',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  message['fileSize'] ?? '',
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _downloadFile(message),
            icon: Icon(
              Icons.download,
              color: isMe ? Colors.white : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF14B8A6) : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: isMe ? Colors.white : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Location Shared',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.map, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message['location']['address'],
            style: TextStyle(
              color: isMe ? Colors.white70 : Colors.grey[700],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openLocation(message['location']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isMe ? Colors.white : const Color(0xFF14B8A6),
                    side: BorderSide(color: isMe ? Colors.white : const Color(0xFF14B8A6)),
                  ),
                  child: const Text('Navigate', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _shareLocation(message['location']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isMe ? Colors.white : const Color(0xFF14B8A6),
                    side: BorderSide(color: isMe ? Colors.white : const Color(0xFF14B8A6)),
                  ),
                  child: const Text('Share', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF14B8A6) : Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _playVoiceMessage(message),
            icon: Icon(
              message['isPlaying'] ? Icons.pause : Icons.play_arrow,
              color: isMe ? Colors.white : const Color(0xFF14B8A6),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice Message',
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message['duration'],
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.mic,
            color: isMe ? Colors.white70 : Colors.grey[600],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildJobReferenceMessage(Map<String, dynamic> message, bool isMe) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.work, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Job Update',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message['content'],
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['jobTitle'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Row(
                  children: [
                    Text('Status: ', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        message['jobStatus'].toUpperCase(),
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _showAttachmentOptions,
            icon: const Icon(Icons.add, color: Color(0xFF14B8A6)),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: 4,
              minLines: 1,
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_hasText) {
                _sendMessage(_messageController.text);
              }
            },
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) => _stopRecording(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _hasText ? const Color(0xFF14B8A6) : Colors.grey[400],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _hasText 
                    ? Icons.send 
                    : (_isRecording ? Icons.stop : Icons.mic),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getReplyContent(String replyId) {
    final replyMessage = _messages.firstWhere(
      (msg) => msg['id'] == replyId,
      orElse: () => {'content': 'Message not found'},
    );
    return replyMessage['content'].toString();
  }

  // Action handlers
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'type': 'text',
      'content': text.trim(),
      'sender': 'Sam Rodriguez',
      'senderAvatar': 'SR',
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _makeVoiceCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallScreen(
          contactName: widget.chat['name'],
          callType: 'voice',
        ),
      ),
    );
  }

  void _makeVideoCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallScreen(
          contactName: widget.chat['name'],
          callType: 'video',
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'info':
        _showChatInfo();
        break;
      case 'mute':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat muted')),
        );
        break;
      case 'search':
        _showSearchMessages();
        break;
      case 'resolve':
        _resolveEmergency();
        break;
      case 'export':
        _exportChat();
        break;
    }
  }

  void _showChatInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChatInfoSheet(chat: widget.chat),
    );
  }

  void _showSearchMessages() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message search coming soon')),
    );
  }

  void _resolveEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Emergency'),
        content: const Text('Mark this emergency as resolved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emergency resolved')),
              );
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _exportChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat export started')),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Send Attachment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                _buildAttachmentOption(Icons.camera_alt, 'Camera', () => _sendAttachment('camera')),
                _buildAttachmentOption(Icons.photo_library, 'Gallery', () => _sendAttachment('gallery')),
                _buildAttachmentOption(Icons.insert_drive_file, 'Document', () => _sendAttachment('document')),
                _buildAttachmentOption(Icons.location_on, 'Location', () => _sendAttachment('location')),
                _buildAttachmentOption(Icons.work, 'Job Reference', () => _sendAttachment('job')),
                _buildAttachmentOption(Icons.inventory, 'Inventory', () => _sendAttachment('inventory')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF14B8A6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: const Color(0xFF14B8A6)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _sendAttachment(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type attachment coming soon')),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice message recorded')),
    );
  }

  void _playVoiceMessage(Map<String, dynamic> message) {
    setState(() {
      message['isPlaying'] = !message['isPlaying'];
    });
  }

  void _openLocation(Map<String, dynamic> location) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening location: ${location['address']}')),
    );
  }

  void _shareLocation(Map<String, dynamic> location) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location shared')),
    );
  }

  void _downloadFile(Map<String, dynamic> message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${message['fileName']}')),
    );
  }
}

// Placeholder screens
class CallScreen extends StatelessWidget {
  final String contactName;
  final String callType;

  const CallScreen({
    super.key,
    required this.contactName,
    required this.callType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calling $contactName...',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            Icon(
              callType == 'video' ? Icons.video_call : Icons.call,
              color: Colors.white,
              size: 64,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInfoSheet extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatInfoSheet({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chat Info - ${chat['name']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (chat['participants'] != null) ...[
            Text('Participants: ${chat['participants'].length}'),
            const SizedBox(height: 8),
            ...chat['participants'].map<Widget>((participant) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $participant'),
              )
            ).toList(),
          ],
        ],
      ),
    );
  }
} 