import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class TeamChatScreen extends StatefulWidget {
  const TeamChatScreen({super.key});

  @override
  State<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<TeamChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _chats = [
    {
      'id': 'chat_001',
      'type': 'emergency',
      'name': 'Emergency Alert',
      'participants': ['Sam Rodriguez', 'Mike Johnson', 'Alex Chen', 'Sarah Williams'],
      'lastMessage': 'URGENT: Equipment failure at Downtown Office - need immediate response!',
      'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 2)),
      'lastMessageSender': 'Dispatch Center',
      'unreadCount': 1,
      'isOnline': true,
      'priority': 'critical',
      'avatar': null,
    },
    {
      'id': 'chat_002',
      'type': 'group',
      'name': 'Field Team Alpha',
      'participants': ['Sam Rodriguez', 'Mike Johnson', 'Alex Chen'],
      'lastMessage': 'Route optimization complete for tomorrow\'s schedule',
      'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 15)),
      'lastMessageSender': 'Alex Chen',
      'unreadCount': 0,
      'isOnline': true,
      'priority': 'normal',
      'avatar': '👥',
    },
    {
      'id': 'chat_003',
      'type': 'direct',
      'name': 'Mike Johnson',
      'role': 'Senior Technician',
      'participants': ['Sam Rodriguez', 'Mike Johnson'],
      'lastMessage': 'Thanks for the HVAC filter info. I\'ll handle the restock.',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 1)),
      'lastMessageSender': 'Mike Johnson',
      'unreadCount': 0,
      'isOnline': true,
      'priority': 'normal',
      'avatar': 'MJ',
    },
    {
      'id': 'chat_004',
      'type': 'direct',
      'name': 'Sarah Williams',
      'role': 'Operations Manager',
      'participants': ['Sam Rodriguez', 'Sarah Williams'],
      'lastMessage': 'Can you review the weekly report before submission?',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 2)),
      'lastMessageSender': 'Sarah Williams',
      'unreadCount': 2,
      'isOnline': false,
      'priority': 'normal',
      'avatar': 'SW',
    },
    {
      'id': 'chat_005',
      'type': 'group',
      'name': 'Pest Control Team',
      'participants': ['Sam Rodriguez', 'Mike Johnson', 'Tom Wilson'],
      'lastMessage': 'Green Valley Restaurant job completed successfully',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 4)),
      'lastMessageSender': 'Tom Wilson',
      'unreadCount': 0,
      'isOnline': true,
      'priority': 'normal',
      'avatar': '🐛',
    },
    {
      'id': 'chat_006',
      'type': 'direct',
      'name': 'Alex Chen',
      'role': 'Team Lead',
      'participants': ['Sam Rodriguez', 'Alex Chen'],
      'lastMessage': 'Safety training reminder sent to all team members',
      'lastMessageTime': DateTime.now().subtract(const Duration(hours: 6)),
      'lastMessageSender': 'Alex Chen',
      'unreadCount': 0,
      'isOnline': true,
      'priority': 'normal',
      'avatar': 'AC',
    },
  ];

  final List<Map<String, dynamic>> _contacts = [
    {
      'id': 'contact_001',
      'name': 'Mike Johnson',
      'role': 'Senior Technician',
      'department': 'HVAC Services',
      'phone': '+1 (555) 123-4567',
      'email': 'mike.johnson@company.com',
      'isOnline': true,
      'avatar': 'MJ',
      'skills': ['HVAC', 'Electrical', 'Plumbing'],
    },
    {
      'id': 'contact_002',
      'name': 'Sarah Williams',
      'role': 'Operations Manager',
      'department': 'Operations',
      'phone': '+1 (555) 234-5678',
      'email': 'sarah.williams@company.com',
      'isOnline': false,
      'avatar': 'SW',
      'skills': ['Project Management', 'Quality Control'],
    },
    {
      'id': 'contact_003',
      'name': 'Alex Chen',
      'role': 'Team Lead',
      'department': 'Field Operations',
      'phone': '+1 (555) 345-6789',
      'email': 'alex.chen@company.com',
      'isOnline': true,
      'avatar': 'AC',
      'skills': ['Leadership', 'Safety Training', 'Route Planning'],
    },
    {
      'id': 'contact_004',
      'name': 'Tom Wilson',
      'role': 'Pest Control Specialist',
      'department': 'Pest Control',
      'phone': '+1 (555) 456-7890',
      'email': 'tom.wilson@company.com',
      'isOnline': true,
      'avatar': 'TW',
      'skills': ['Pest Control', 'Chemical Safety', 'Customer Service'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredChats {
    if (_searchQuery.isEmpty) return _chats;
    
    return _chats.where((chat) {
      final name = chat['name'].toString().toLowerCase();
      final lastMessage = chat['lastMessage'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredContacts {
    if (_searchQuery.isEmpty) return _contacts;
    
    return _contacts.where((contact) {
      final name = contact['name'].toString().toLowerCase();
      final role = contact['role'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || role.contains(query);
    }).toList();
  }

  int get _totalUnreadCount => _chats.fold(0, (sum, chat) => sum + (chat['unreadCount'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Team Chat'),
            if (_totalUnreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_totalUnreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: _startGroupCall,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showNewChatOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chats', icon: Icon(Icons.chat)),
            Tab(text: 'Contacts', icon: Icon(Icons.people)),
            Tab(text: 'Calls', icon: Icon(Icons.call)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chats, contacts, or messages...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatsTab(),
                _buildContactsTab(),
                _buildCallsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEmergencyBroadcast,
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }

  Widget _buildChatsTab() {
    final chats = _filteredChats;
    
    if (chats.isEmpty) {
      return _buildEmptyState('No chats found', 'Start a conversation or adjust your search');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildChatCard(chat),
        );
      },
    );
  }

  Widget _buildContactsTab() {
    final contacts = _filteredContacts;
    
    if (contacts.isEmpty) {
      return _buildEmptyState('No contacts found', 'Check your search terms');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildContactCard(contact),
        );
      },
    );
  }

  Widget _buildCallsTab() {
    final callHistory = [
      {
        'name': 'Mike Johnson',
        'type': 'video',
        'direction': 'incoming',
        'duration': '12:34',
        'time': DateTime.now().subtract(const Duration(hours: 1)),
        'status': 'completed',
      },
      {
        'name': 'Field Team Alpha',
        'type': 'video',
        'direction': 'outgoing',
        'duration': '45:12',
        'time': DateTime.now().subtract(const Duration(hours: 3)),
        'status': 'completed',
      },
      {
        'name': 'Sarah Williams',
        'type': 'voice',
        'direction': 'missed',
        'duration': null,
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'status': 'missed',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: callHistory.length,
      itemBuilder: (context, index) {
        final call = callHistory[index];
        return _buildCallHistoryCard(call);
      },
    );
  }

  Widget _buildChatCard(Map<String, dynamic> chat) {
    final bool hasUnread = chat['unreadCount'] > 0;
    final bool isEmergency = chat['type'] == 'emergency';
    
    return Card(
      elevation: hasUnread ? 4 : 1,
      color: isEmergency ? Colors.red[50] : (hasUnread ? Colors.white : Colors.grey[50]),
      child: InkWell(
        onTap: () => _openChat(chat),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isEmergency ? Colors.red : const Color(0xFF14B8A6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: chat['avatar'] != null
                          ? Text(
                              chat['avatar'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Icon(
                              isEmergency ? Icons.emergency : Icons.group,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ),
                  if (chat['isOnline'])
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              
              // Chat Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat['name'],
                            style: TextStyle(
                              fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                              fontSize: 16,
                              color: isEmergency ? Colors.red[800] : null,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(chat['lastMessageTime']),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (chat['lastMessageSender'] != null) ...[
                          Text(
                            '${chat['lastMessageSender']}: ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            chat['lastMessage'],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isEmergency ? Colors.red : const Color(0xFF14B8A6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${chat['unreadCount']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
        ),
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Card(
      child: InkWell(
        onTap: () => _openDirectChat(contact),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B8A6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        contact['avatar'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (contact['isOnline'])
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              
              // Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      contact['role'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      contact['department'],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.call, color: Color(0xFF14B8A6)),
                    onPressed: () => _makeCall(contact, 'voice'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.video_call, color: Color(0xFF14B8A6)),
                    onPressed: () => _makeCall(contact, 'video'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallHistoryCard(Map<String, dynamic> call) {
    final IconData callIcon = call['type'] == 'video' ? Icons.video_call : Icons.call;
    final Color statusColor = call['status'] == 'missed' ? Colors.red : Colors.green;
    final IconData directionIcon = call['direction'] == 'incoming' 
        ? Icons.call_received 
        : call['direction'] == 'outgoing' 
            ? Icons.call_made 
            : Icons.call_received;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(callIcon, color: statusColor),
        ),
        title: Text(call['name']),
        subtitle: Row(
          children: [
            Icon(directionIcon, size: 16, color: statusColor),
            const SizedBox(width: 4),
            Text(_formatTime(call['time'])),
            if (call['duration'] != null) ...[
              const Text(' • '),
              Text(call['duration']),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(callIcon, color: const Color(0xFF14B8A6)),
          onPressed: () => _makeCall({'name': call['name']}, call['type']),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  // Action handlers
  void _openChat(Map<String, dynamic> chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chat: chat),
      ),
    );
  }

  void _openDirectChat(Map<String, dynamic> contact) {
    final chat = {
      'id': 'chat_new_${contact['id']}',
      'type': 'direct',
      'name': contact['name'],
      'participants': ['Sam Rodriguez', contact['name']],
      'messages': [],
    };
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chat: chat),
      ),
    );
  }

  void _makeCall(Map<String, dynamic> contact, String type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallScreen(
          contactName: contact['name'],
          callType: type,
        ),
      ),
    );
  }

  void _startGroupCall() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const GroupCallSheet(),
    );
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const NewChatSheet(),
    );
  }

  void _showEmergencyBroadcast() {
    showDialog(
      context: context,
      builder: (context) => const EmergencyBroadcastDialog(),
    );
  }
}



class GroupCallSheet extends StatelessWidget {
  const GroupCallSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Start Group Call',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Group call functionality coming soon!'),
        ],
      ),
    );
  }
}

class NewChatSheet extends StatelessWidget {
  const NewChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'New Chat',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('New chat options coming soon!'),
        ],
      ),
    );
  }
}

class EmergencyBroadcastDialog extends StatelessWidget {
  const EmergencyBroadcastDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.emergency, color: Colors.red),
          SizedBox(width: 8),
          Text('Emergency Broadcast'),
        ],
      ),
      content: const Text(
        'Send an emergency message to all team members. This should only be used for critical situations requiring immediate attention.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Emergency broadcast sent!')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Send Emergency', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
} 