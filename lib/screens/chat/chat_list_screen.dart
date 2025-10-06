import 'package:flutter/material.dart';
import '../../models/chat.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatRoom> chatRooms = [];

  @override
  void initState() {
    super.initState();
    loadChatRooms();
  }

  void loadChatRooms() {
    // Mock data
    chatRooms = [
      ChatRoom(
        id: 'chat1',
        participants: ['user1', 'seller1'],
        lastMessage: 'Produk masih tersedia?',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 30)),
        isRead: false,
      ),
      ChatRoom(
        id: 'chat2',
        participants: ['user1', 'seller2'],
        lastMessage: 'Terima kasih',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
        isRead: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesan'), backgroundColor: Colors.green),
      body: chatRooms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Belum ada percakapan'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    _getOtherParticipant(chatRoom.participants),
                    style: TextStyle(
                      fontWeight: chatRoom.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    chatRoom.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: chatRoom.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(chatRoom.lastMessageTime),
                        style: TextStyle(fontSize: 12),
                      ),
                      if (!chatRoom.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatDetailScreen(chatRoom: chatRoom),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _getOtherParticipant(List<String> participants) {
    // In real app, get participant name from user ID
    return participants.firstWhere((p) => p != 'user1');
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inMinutes}m';
    }
  }
}
