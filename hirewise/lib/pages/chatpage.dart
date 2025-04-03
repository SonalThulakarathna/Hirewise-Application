import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _messagesStreamController =
      StreamController<List<Map<String, dynamic>>>();

  @override
  void initState() {
    super.initState();
    _subscribeToMessages();
  }

  @override
  void dispose() {
    _messagesStreamController.close();
    super.dispose();
  }

  void _subscribeToMessages() {
    final subscription = _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .listen((List<Map<String, dynamic>> messages) {
          _messagesStreamController.add(messages);
        });
  }

  Future<void> _sendMessage() async {
    final user = _supabase.auth.currentUser;
    if (user == null || _messageController.text.isEmpty) return;

    await _supabase.from('messages').insert([
      {
        'sender_id': user.id,
        'receiver_id':
            'receiver_id', // You should use the receiver's user ID here
        'message': _messageController.text,
        'created_at': DateTime.now().toIso8601String(),
      },
    ]);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messagesStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['message']),
                      subtitle: Text('From: ${message['sender_id']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
