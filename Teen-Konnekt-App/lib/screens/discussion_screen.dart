import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class DiscussionScreen extends StatefulWidget {
  @override
  _DiscussionScreenState createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _discussionCollection =
      FirebaseFirestore.instance.collection('discussion');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _hasText = false;
  String _userName = "You";
  String? _editingDocId;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.isNotEmpty;
      });
    });
    _getUserName();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Fetch the user name from the "appointments" collection using the email
  Future<void> _getUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('email', isEqualTo: user.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _userName = snapshot.docs.first['name'] ?? "You";
        });
      }
    }
  }

  Future<void> _addOrUpdateDiscussion(String message) async {
    if (_editingDocId != null) {
      // Update existing discussion
      await _discussionCollection.doc(_editingDocId).update({
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
      });
      _editingDocId = null;
    } else {
      // Add new discussion
      User? user = _auth.currentUser;
      await _discussionCollection.add({
        "name": _userName,
        "email": user?.email ?? "anonymous",
        "message": message,
        "likes": 0,
        "likedBy": [],
        "timestamp": FieldValue.serverTimestamp(),
      });
    }
    _messageController.clear();
  }

  Future<void> _deleteDiscussion(String docId) async {
    await _discussionCollection.doc(docId).delete();
  }

  Future<void> _toggleLike(String docId, int currentLikes, List likedBy) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    String userId = user.uid;

    if (likedBy.contains(userId)) {
      await _discussionCollection.doc(docId).update({
        "likes": currentLikes - 1,
        "likedBy": FieldValue.arrayRemove([userId]),
      });
    } else {
      await _discussionCollection.doc(docId).update({
        "likes": currentLikes + 1,
        "likedBy": FieldValue.arrayUnion([userId]),
      });
    }
  }

  String _calculateTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return "Just Now";

    DateTime postTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inMinutes < 1) {
      return "Just Now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    } else {
      return "${difference.inDays} day(s) ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text(
          'Discussion',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _discussionCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final discussions = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = discussions[index];
                    final data = discussion.data() as Map<String, dynamic>;
                    return _buildDiscussionCard(
                      docId: discussion.id,
                      name: data["name"] ?? _userName,
                      email: data["email"] ?? "",
                      message: data["message"] ?? "",
                      likes: data["likes"] ?? 0,
                      likedBy: data["likedBy"] ?? [],
                      timeAgo:
                          _calculateTimeAgo(data["timestamp"] as Timestamp?),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    constraints: BoxConstraints(
                      minHeight: 48,
                      maxHeight: 150,
                    ),
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: _editingDocId == null
                            ? 'Write a message'
                            : 'Edit your message',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (_hasText)
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        _addOrUpdateDiscussion(_messageController.text);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionCard({
    required String docId,
    required String name,
    required String email,
    required String message,
    required int likes,
    required List likedBy,
    required String timeAgo,
  }) {
    User? user = _auth.currentUser;
    bool isLiked = user != null && likedBy.contains(user.uid);
    bool isOwnPost = user != null && user.email == email;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/profile_pic.png'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (isOwnPost)
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'Edit') {
                              setState(() {
                                _messageController.text = message;
                                _editingDocId = docId;
                              });
                            } else if (value == 'Delete') {
                              final shouldDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text(
                                      'Do you really want to delete this?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (shouldDelete == true) {
                                _deleteDiscussion(docId);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'Edit', child: Text('Edit')),
                            PopupMenuItem(
                                value: 'Delete', child: Text('Delete')),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleLike(docId, likes, likedBy);
                            },
                          ),
                          Text(
                            likes.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
