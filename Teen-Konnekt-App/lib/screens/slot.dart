import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class SlotBookingPage extends StatefulWidget {
  final String name;
  final String sex;
  final String yearOfBirth;
  final String problem;

  SlotBookingPage({
    required this.name,
    required this.sex,
    required this.yearOfBirth,
    required this.problem,
  });

  @override
  _SlotBookingPageState createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  DateTime _selectedDate = DateTime.now();
  final User? _currentUser =
      FirebaseAuth.instance.currentUser; // Get the logged-in user

  // Method to save data to Firestore
  Future<void> _saveAppointment(
      BuildContext context, DateTime selectedDate) async {
    try {
      if (_currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You need to log in to book an appointment.')),
        );
        return;
      }

      // Save only the date part as a string (e.g., "2024-11-24")
      String formattedDate = selectedDate.toIso8601String().split('T').first;

      await FirebaseFirestore.instance.collection('appointments').add({
        'name': widget.name,
        'sex': widget.sex,
        'yearOfBirth': widget.yearOfBirth,
        'problem': widget.problem,
        'selectedDate': formattedDate,
        'email': _currentUser.email, // Include the logged-in user's email
        'createdAt': FieldValue.serverTimestamp(), // Optional: Add a timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment successfully saved!')),
      );
    } catch (e) {
      print('Error saving appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save appointment. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'SLOT BOOKING',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Choose A Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 12, 31),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green, // Highlight selected day
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white, // White text for the selected day
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.white, // Make today's text white
                  ),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.green),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.green),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(
                      _selectedDate, day); // Return true for the selected day
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (selectedDay.isAfter(DateTime.now())) {
                    setState(() {
                      _selectedDate = selectedDay; // Update the selected day
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('You can only select future dates.')),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 35),
          // Available Slot button
          SizedBox(
            width: 250, // Adjust width as per your requirement (e.g., 250)
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10), // Reduced vertical padding
              ),
              onPressed: () async {
                // Save the appointment to Firestore
                await _saveAppointment(context, _selectedDate);

                // Redirect to the Welcome page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text(
                "Submit the Appointment",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
