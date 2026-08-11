import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool eventReminder = true;
  bool newEvents = true;
  bool registrationUpdates = true;
  bool organizerAnnouncements = false;
  bool aiRecommendations = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      eventReminder =
          prefs.getBool('eventReminder') ?? true;

      newEvents =
          prefs.getBool('newEvents') ?? true;

      registrationUpdates =
          prefs.getBool('registrationUpdates') ?? true;

      organizerAnnouncements =
          prefs.getBool('organizerAnnouncements') ?? false;

      aiRecommendations =
          prefs.getBool('aiRecommendations') ?? true;
    });
  }

  Future<void> saveSetting(
      String key,
      bool value,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget notificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Card(
      color: const Color(0xff1B2342),
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        activeColor: Colors.deepPurpleAccent,
        secondary: Icon(
          icon,
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),

      appBar: AppBar(
        backgroundColor: const Color(0xff0D1028),
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            notificationTile(
              title: "Event Reminders",
              subtitle:
              "Get reminders before registered events.",
              icon: Icons.event,
              value: eventReminder,
              onChanged: (value) {
                setState(() {
                  eventReminder = value;
                });
                saveSetting("eventReminder", value);
              },
            ),

            notificationTile(
              title: "New Event Alerts",
              subtitle:
              "Receive notifications for newly added events.",
              icon: Icons.notifications_active,
              value: newEvents,
              onChanged: (value) {
                setState(() {
                  newEvents = value;
                });
                saveSetting("newEvents", value);
              },
            ),

            notificationTile(
              title: "Registration Updates",
              subtitle:
              "Notify me about registration status.",
              icon: Icons.app_registration,
              value: registrationUpdates,
              onChanged: (value) {
                setState(() {
                  registrationUpdates = value;
                });
                saveSetting("registrationUpdates", value);
              },
            ),

            notificationTile(
              title: "Organizer Announcements",
              subtitle:
              "Receive announcements from organizers.",
              icon: Icons.campaign,
              value: organizerAnnouncements,
              onChanged: (value) {
                setState(() {
                  organizerAnnouncements = value;
                });
                saveSetting(
                    "organizerAnnouncements",
                    value);
              },
            ),

            notificationTile(
              title: "AI Recommendations",
              subtitle:
              "Receive AI-based event suggestions.",
              icon: Icons.smart_toy,
              value: aiRecommendations,
              onChanged: (value) {
                setState(() {
                  aiRecommendations = value;
                });
                saveSetting(
                    "aiRecommendations",
                    value);
              },
            ),

            const SizedBox(height: 20),

            const Card(
              color: Color(0xff1B2342),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.deepPurpleAccent,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Notification preferences are saved on your device.",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}