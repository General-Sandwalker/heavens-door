import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/message_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false).fetchConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          if (messageProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (messageProvider.conversations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message_outlined, size: 64),
                  SizedBox(height: 16),
                  Text('No messages yet'),
                  Text('Start a conversation with a property owner!'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: messageProvider.conversations.length,
            itemBuilder: (context, index) {
              final conversation = messageProvider.conversations[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(conversation['firstName'][0]),
                ),
                title: Text(
                  '${conversation['firstName']} ${conversation['lastName']}',
                ),
                subtitle: Text(
                  conversation['lastMessage']['content'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  conversation['lastMessage']['createdAt'].toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  // TODO: Navigate to chat screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
