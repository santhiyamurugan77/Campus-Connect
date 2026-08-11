import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),

      appBar: AppBar(
        backgroundColor: const Color(0xff0D1028),
        elevation: 0,
        title: const Text(
          "About CampusConnect",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "CampusConnect",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Version 1.0",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              color: const Color(0xff1B2342),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  "CampusConnect is a smart event management platform that helps students discover, register, and participate in college events across different institutions.\n\nThe application provides AI-based event recommendations, event registration, organizer dashboards, favorite events, and profile management through a modern Flutter interface.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Features",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            feature(Icons.search, "Search College Events"),
            feature(Icons.app_registration, "Easy Event Registration"),
            feature(Icons.favorite, "Favorite Events"),
            feature(Icons.smart_toy, "AI Event Guide"),
            feature(Icons.dashboard, "Organizer Dashboard"),
            feature(Icons.person, "Student Profile"),
            feature(Icons.notifications, "Notifications"),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Technologies Used",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            technology("Flutter", Icons.phone_android),
            technology("Dart", Icons.code),
            technology("Supabase", Icons.storage),
            technology("Python Flask", Icons.cloud),
            technology("SQL Database", Icons.table_chart),

            const SizedBox(height: 30),

            const Divider(color: Colors.white24),

            const SizedBox(height: 15),

            const Text(
              "Developed By",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Santhiya K.M.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Final Year Project",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "© 2026 CampusConnect\nAll Rights Reserved",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget feature(IconData icon, String title) {
    return Card(
      color: const Color(0xff1B2342),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget technology(String title, IconData icon) {
    return Card(
      color: const Color(0xff1B2342),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurpleAccent),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}