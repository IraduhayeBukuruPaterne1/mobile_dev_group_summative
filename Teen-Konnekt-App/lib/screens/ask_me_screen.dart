import 'package:flutter/material.dart';

import 'home.dart';

class AskMeScreen extends StatefulWidget {
  @override
  _AskMeScreenState createState() => _AskMeScreenState();
}

class _AskMeScreenState extends State<AskMeScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isMessageNotEmpty = false;

  // List to hold the messages
  List<Map<String, dynamic>> _messages = [
    {'text': 'Hi, how can I help you?', 'isUser': false},
    {'text': 'I wanted to ask about the effects of...?', 'isUser': true},
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isMessageNotEmpty = _messageController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text(
          'Ask Me',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Profile of the user asking the question
          Row(
            children: [
              SizedBox(width: 16),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                    'assets/profile_pic.png'), // Replace with actual profile image asset
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Hello! I have a question about health.',
                    style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildChatBubble(
                      _messages[index]['text'],
                      _messages[index]['isUser'],
                    ),
                    SizedBox(height: 10), // Added space between messages
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.green),
                  onPressed: () {
                    // Attachment action
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Write a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                _isMessageNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.send, color: Colors.green),
                        onPressed: () {
                          // Send message action
                          setState(() {
                            _messages.add({
                              'text': _messageController.text,
                              'isUser': true,
                            });
                          });
                          _messageController
                              .clear(); // Clear message after sending
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.mic, color: Colors.green),
                        onPressed: () {
                          // Record action
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
      ),
    );
  }
}
