import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  final VoidCallback? onAccountUpdated;

  AccountScreen({this.onAccountUpdated});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _currentEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      _currentEmailController.text = user.email ?? '';
    }
  }

  Future<void> _reauthenticate(String password) async {
    try {
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: password,
      );
      await user?.reauthenticateWithCredential(credential);
    } catch (e) {
      throw 'Re-authentication failed. Please check your password.';
    }
  }

  Future<void> _updateEmail() async {
    if (_currentEmailController.text.trim().isEmpty ||
        _currentPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter your current email and password.')),
      );
      return;
    }

    if (_emailController.text.trim() == _currentEmailController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'The new email address must be different from the current email.')),
      );
      return;
    }

    try {
      final currentPassword = _currentPasswordController.text.trim();
      await _reauthenticate(currentPassword);

      final user = _auth.currentUser;
      if (user != null) {
        // Send a verification email to the new email
        final newEmail = _emailController.text.trim();
        await user.verifyBeforeUpdateEmail(newEmail);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'A verification email has been sent to $newEmail. Please verify it and log in again.')),
        );

        // Sign the user out after sending the email
        await _auth.signOut();
        widget.onAccountUpdated?.call();
      }
    } catch (e) {
      String message = 'Error updating email.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            message = 'The new email is already in use by another account.';
            break;
          case 'invalid-email':
            message = 'The new email address is invalid.';
            break;
          case 'requires-recent-login':
            message = 'Please log in again to update your email.';
            break;
          default:
            message = 'An unknown error occurred: ${e.message}';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _updatePassword() async {
    if (_currentPasswordController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please enter your current password and new password.')),
      );
      return;
    }

    try {
      final currentPassword = _currentPasswordController.text.trim();
      await _reauthenticate(currentPassword);

      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_passwordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Password updated successfully. You will now be signed out.')),
        );

        await _auth.signOut();
        widget.onAccountUpdated?.call();
      }
    } catch (e) {
      String message = 'Error updating password.';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            message = 'The new password is too weak.';
            break;
          case 'requires-recent-login':
            message = 'Please log in again to update your password.';
            break;
          default:
            message = 'An unknown error occurred: ${e.message}';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current email input (for verification before update)
              TextField(
                controller: _currentEmailController,
                decoration: InputDecoration(
                  labelText: 'Current Email',
                  border: OutlineInputBorder(),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                enabled: false, // Current email is displayed but not editable
              ),
              SizedBox(height: 20),

              // Current password input (for verification before update)
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // New email input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEmail,
                child: Text('Update Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20),

              // New password input
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePassword,
                child: Text('Update Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
