import 'package:flutter/material.dart';

class FAQsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color as seen in the image
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back navigation
          },
        ),
        title: Text(
          'FAQs',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Title color
            fontFamily: 'Roboto', // Using modern font style
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
        backgroundColor: Colors.blueAccent, // AppBar background color
        elevation: 0, // Remove shadow under AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            // Question 1
            _buildFaqCard(
              'What is sexual and reproductive health?',
              'Sexual and reproductive health refers to the physical, emotional, mental, and social well-being related to all matters of the reproductive system.',
            ),
            SizedBox(height: 20),

            // Question 2
            _buildFaqCard(
              'At what age should I start learning about sexual health?',
              'It’s important to start learning about sexual health as soon as you begin puberty, typically between ages 9 and 14.',
            ),
            SizedBox(height: 20),

            // Question 3
            _buildFaqCard(
              'What are the signs of puberty, and when does it start?',
              'Puberty usually begins between ages 9 and 14.',
            ),
            SizedBox(height: 20),

            // Question 4
            _buildFaqCard(
              'How can I protect myself from sexually transmitted infections (STIs)?',
              'To protect yourself from STIs, practice safe sex by using condoms consistently, get vaccinated against HPV, and avoid sharing personal items like razors.',
            ),
            SizedBox(height: 20),

            // Question 5
            _buildFaqCard(
              'What is contraception, and what methods are available for adolescents?',
              'Contraception refers to methods used to prevent pregnancy. Common contraceptives for adolescents include condoms, birth control pills, implants, and emergency contraception.',
            ),
            SizedBox(height: 20),

            // Question 6
            _buildFaqCard(
              'What should I do if I experience peer pressure to have sex?',
              'If you feel pressured to have sex, it’s important to remember that you choose when, if ever, to engage in sexual activity.',
            ),
            SizedBox(height: 20),

            // Question 7
            _buildFaqCard(
              'What should I do if I think I’m pregnant?',
              'If you suspect you might be pregnant, the first step is to take a pregnancy test, which you can get at a pharmacy or a health clinic.',
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqCard(String question, String answer) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.blueGrey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Accent color for questions
                fontFamily: 'Roboto', // Modern font
              ),
            ),
            SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87, // Lighter color for the answer text
                fontFamily: 'Roboto', // Consistent font usage
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FAQsPage(),
  ));
}
