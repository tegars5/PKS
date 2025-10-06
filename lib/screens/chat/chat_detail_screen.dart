import 'package:flutter/material.dart';
import '../../models/chat.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  ChatDetailScreen({required this.chatRoom});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Message> messages = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  void loadMessages() {
    // Mock messages
    messages = [
      Message(
        id: 'msg1',
        senderId: 'seller1',
        receiverId: 'user1',
        content: 'Halo, ada yang bisa saya bantu?',
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: true,
      ),
      Message(
        id: 'msg2',
        senderId: 'user1',
        receiverId: 'seller1',
        content: 'Produk cangkang sawit masih tersedia?',
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        isRead: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getOtherParticipant()),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Implement call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == 'user1';

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isMe ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final message = Message(
      id: 'msg${messages.length + 1}',
      senderId: 'user1',
      receiverId: _getOtherParticipantId(),
      content: messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      messages.add(message);
      messageController.clear();
    });

    // Scroll to bottom
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _getOtherParticipant() {
    return widget.chatRoom.participants.firstWhere((p) => p != 'user1');
  }

  String _getOtherParticipantId() {
    return widget.chatRoom.participants.firstWhere((p) => p != 'user1');
  }
}
