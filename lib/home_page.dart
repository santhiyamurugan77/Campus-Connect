import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'find_events_page.dart';
import 'ai_guide_page.dart';
import 'organizer_page.dart';
import 'my_registrations_page.dart';
import 'settings_page.dart';
import 'favorite_events_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> events = const [
    {
      "title": "National Symposium on AI & ML",
      "college": "Anna University",
      "location": "Chennai, Tamil Nadu",
      "date": "12 May 2026",
      "category": "TECH",
    },
    {
      "title": "Dance Fest",
      "college": "Saveetha Engineering College",
      "location": "Chennai",
      "date": "07 Feb 2026",
      "category": "CULTURAL",
    },
    {
      "title": "Workshop",
      "college": "AVS College",
      "location": "Villupuram",
      "date": "20 Mar 2026",
      "category": "WORKSHOP",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),
      drawer: Drawer(
        backgroundColor: const Color(0xff161D3A),
        child: SafeArea(
          child: Column(
            children: [

              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.school,
                          color: Colors.deepPurple,
                          size: 35,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "CampusConnect",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.event_available,color: Colors.white),
                title: const Text(
                  "My Registrations",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyRegistrationsPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.favorite,color: Colors.red),
                title: const Text(
                  "Favorite Events",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoriteEventsPage(),
                    ),
                  );
                },
              ),

              const Divider(color: Colors.white24),

              ListTile(
                leading: const Icon(Icons.dashboard,color: Colors.deepPurpleAccent),
                title: const Text(
                  "Organizer Dashboard",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrganizerPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings,color: Colors.white),
                title: const Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsPage(),
                    ),
                  );
                },
              ),

              const Spacer(),

              const Divider(color: Colors.white24),

              ListTile(
                leading: const Icon(Icons.logout,color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();

                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                          (route) => false,
                    );
                  }
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff0D1028),
        elevation: 0,
        title: const Text(
          "CampusConnect",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "🔥 9 Events Live Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Discover College Events\nAcross India",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Find conferences, workshops,\nhackathons, symposiums,\nand cultural events.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FindEventsPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: const Text("Find Events"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AIGuidePage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.smart_toy,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "AI Guide",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: "9",
                      subtitle: "Events",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "1",
                      subtitle: "State",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: "6",
                      subtitle: "Categories",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Text(
                "Featured Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EventCard(
                      title: events[index]["title"]!,
                      college: events[index]["college"]!,
                      location: events[index]["location"]!,
                      date: events[index]["date"]!,
                      category: events[index]["category"]!,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xff1B2342),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String college;
  final String location;
  final String date;
  final String category;

  const EventCard({
    super.key,
    required this.title,
    required this.college,
    required this.location,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1B2342),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "$college\n$location\n$date",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Chip(
          label: Text(category),
        ),
      ),
    );
  }
}