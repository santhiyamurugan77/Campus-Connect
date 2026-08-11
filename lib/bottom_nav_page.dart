import 'package:flutter/material.dart';
import 'package:campusconnect/home_page.dart';
import 'package:campusconnect/events_page.dart';
import 'package:campusconnect/find_events_page.dart';
import 'package:campusconnect/ai_guide_page.dart';
import 'package:campusconnect/profile_page.dart';

class BottomNavPage extends StatefulWidget {
  final int initialIndex;

  const BottomNavPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  final List<Widget> pages = const [
    HomePage(),
    EventsPage(),
    FindEventsPage(),
    AIGuidePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff111633),

        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: "AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}