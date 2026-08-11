import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    final response = await Supabase.instance.client
        .from('events')
        .select();

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2147),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1325),
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.deepPurpleAccent),
            SizedBox(width: 8),
            Text(
              "CampusConnect",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text(
                "No Events Available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: EventCard(
                  eventId: event['id'],
                  category: event['category'] ?? "",
                  title: event['title'] ?? "",
                  college: event['college'] ?? "",
                  location: "${event['city']}, ${event['state']}",
                  date: event['date'].toString(),
                  seats: event['seats'].toString(),
                  description: event['description'] ?? "",
                  mapLink: event['map_link'] ?? "",
                ),
              );
            },
          );

        },
      ),
    );
  }
}