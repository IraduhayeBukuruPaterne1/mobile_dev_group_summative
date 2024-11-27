import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore
import 'landing_page.dart';
import 'AccountScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String username = "Username"; // Default username

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final email = currentUser.email;
      if (email == null) return;

      // Query Firestore for the appointment created by the logged-in user
      final snapshot = await _firestore
          .collection('appointments') // Replace with your collection name
          .where('email', isEqualTo: email) // Assuming 'email' is a field
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Fetch the name field from the first document
        final name = snapshot.docs.first.data()['name'];
        setState(() {
          username = name ?? "Username"; // Fallback if name is null
        });
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
          SizedBox(height: 30),
          // Profile Picture
          CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage(
                'assets/profile_pic.png'), // Adjust with your image asset
          ),
          SizedBox(height: 12),
          // Dynamic Username Display
          Center(
            child: Text(
              username,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          SizedBox(height: 25),

          // Profile Options
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                _buildProfileOption(context, 'Account', Icons.account_circle,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountScreen(
                        onAccountUpdated: () {
                          _handleAccountUpdate(context);
                        },
                      ),
                    ),
                  );
                }),
                _buildProfileOption(context, 'Personal Info', Icons.person, () {
                  // Add navigation or action for 'Personal Info'
                }),
                _buildProfileOption(context, 'Privacy', Icons.lock, () {
                  // Add navigation or action for 'Privacy'
                }),
                _buildProfileOption(context, 'Languages', Icons.language, () {
                  // Add navigation or action for 'Languages'
                }),
                _buildProfileOption(context, 'Help', Icons.help_outline, () {
                  // Add navigation or action for 'Help'
                }),
                _buildLogoutOption(context, 'Log out', Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey[800],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutOption(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.red, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey[800],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () async {
          await _logout(context);
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Log out the user and navigate to the landing page
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: ${e.toString()}')),
      );
    }
  }

  void _handleAccountUpdate(BuildContext context) async {
    // Log out the user and navigate to the landing page after account update
    await _logout(context);
  }
}
