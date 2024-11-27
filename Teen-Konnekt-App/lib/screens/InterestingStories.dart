import 'package:flutter/material.dart';

import 'home.dart';

class InterestingStoriesPage extends StatefulWidget {
  @override
  _interestingPageState createState() => _interestingPageState();
}

class _interestingPageState extends State<InterestingStoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8), // Background color to match the image
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ); // Back navigation
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://yt3.ggpht.com/7wHbOtWZt7aoXZ_gjZU3bG6d9ET6QiL2g5QD37KMRwC0y6ZoSf942T7pxkjY0rxfAya9I0WKNq2T-w=s400-fcrop64=1,16a60000e959ffff-rw-nd-v1', // Replace with actual logo URL
              height: 150, width: 200,
            ),
            SizedBox(width: 30),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for articles',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFFFFBE5), // Yellowish background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Stories List
            Expanded(
              child: ListView(
                children: [
                  _buildStoryCard(
                    'https://yt3.ggpht.com/w3k3nDj25ruGZkDFSnQLx8LW8iRaw1wOVKiUJRNtuYHaxNs9XvDsK1nnL8IpoL2QBkgtWXlXbaNJuw=s576-rw-nd-v1', // Replace with first story image URL
                    'How to Declutter Your Digital Life',
                    '100',
                    '26',
                  ),
                  SizedBox(height: 20),
                  _buildStoryCard(
                    'https://yt3.ggpht.com/ImNXje6-Lv5OWWPJuxSiGvxWmqzKXNyorq5SyeT8lVMWZySsXTCiYf1sDS5AMTpERnNbrFlr0PCj7w=s558-rw-nd-v1', // Replace with second story image URL
                    'The Brain\'s Battle of Choices',
                    '90',
                    '26',
                  ),
                  SizedBox(height: 20),
                  _buildStoryCard(
                    'https://yt3.ggpht.com/-Ey-aJ6jLz9LsJkJoiSiYqstsa3xAu2Ajj-fAd3HGaEmNzmLv6Q-JFI3Bz2JeJAaBYlt70Lbdcxe_w=s569-rw-nd-v1', // Replace with third story image URL
                    'Teenage Engineering – The next innovation',
                    '100',
                    '30',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build story cards
  Widget _buildStoryCard(
      String imageUrl, String title, String views, String comments) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image part of the card
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imageUrl, // Use network image URL
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(views),
                    SizedBox(width: 20),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(comments),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
