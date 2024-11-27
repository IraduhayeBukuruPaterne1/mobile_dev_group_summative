import 'package:flutter/material.dart';

import 'FAQs.dart';
import 'InterestingStories.dart';
import 'appointment_info_page.dart';
import 'ask_me_screen.dart';
import 'discussion_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Variable to track selected tab

  // List of pages corresponding to each navbar item
  List<Widget> _pages = [
    HomePageContent(), // Home screen content
    AppointmentInfoPage(), // Booking screen
    DiscussionScreen(), // Discussion screen
    ProfileScreen() // Profile screen
  ];

  // Function to handle tap on navbar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeenKonnekt'), // Title of the app
        elevation: 0, // No elevation for the app bar
        backgroundColor:
            Colors.transparent, // Transparent background for the app bar
        foregroundColor: Colors.black, // Black color for the text
      ),
      body:
          _pages[_selectedIndex], // Show the page corresponding to selected tab

      // Bottom Navigation Bar with updated colors
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.green[800]), // Dark green icon
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online,
                color: Colors.green[800]), // Dark green icon
            label: 'Booking',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline,
                color: Colors.green[800]), // Dark green icon
            label: 'Discussion',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline,
                color: Colors.green[800]), // Dark green icon
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex, // Set selected index dynamically
        onTap: _onItemTapped, // Handle bottom navigation item taps
        unselectedItemColor:
            Colors.black, // Unselected icon text color (black for contrast)
        selectedItemColor:
            Colors.green[800], // Selected item color (dark green)
        backgroundColor: Colors.white, // Background color of the navbar
      ),
    );
  }
}

// Home Page Content
class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),

          // Cards Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                // Ask Me Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AskMeScreen()),
                    );
                  },
                  child: Card(
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(
                        'Ask Me',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Discussion Room Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscussionScreen()),
                    );
                  },
                  child: Card(
                    color: Colors.lightGreenAccent,
                    child: Center(
                      child: Text(
                        'Discussion Room',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // FAQs Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQsPage()),
                    );
                  },
                  child: Card(
                    color: Colors.orangeAccent,
                    child: Center(
                      child: Text(
                        'FAQs',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // Talk to Our Expert Card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentInfoPage()),
                    );
                  },
                  child: Card(
                    color: Colors.lightBlue,
                    child: Center(
                      child: Text(
                        'Talk to Our Expert',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Interesting Stories (Larger Card)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InterestingStoriesPage()),
                );
              },
              child: Card(
                color: Colors.brown.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'Interesting Stories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Enter Our Discussion Room Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiscussionScreen()),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Want to learn new topic about subject?\nEnter Our Discussion Room',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
