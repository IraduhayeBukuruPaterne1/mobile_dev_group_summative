import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailPage(),
    );
  }
}

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The top section with the yellow background
            Stack(
              children: [
                Container(
                  height: 200,
                  color: Colors.yellow[700],
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      // Handle favorite action
                    },
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 16,
                  child: Text(
                    "How to Declutter Your Digital Life",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Technology",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 6, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "6h ago",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Online image
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: Image.network(
                      'https://example.com/path-to-your-image.png', // Replace with actual URL of the image
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "We have gone through a long way since the development of the internet. What started with a simple network connecting a few people or a small community has changed into a massive system connecting billions of people. We all are going through a digital boom right now because of the advances in artificial intelligence, cheaper internet, and easy access to technological services, all of this has resulted in billions of apps and services aiming for different uses, each of them useful in their ways. The overwhelming option of apps has made us cluttered in our digital lives...",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5, // Adjust line height
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "There is an app for almost every single aspect of our life from simple messaging to maintaining our health. In this article we will be looking at how to keep your apps and digital life clean. As we've seen sometime in 2019, while overall sales were down 8% compared to last year and up only 7% compared to...",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
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
