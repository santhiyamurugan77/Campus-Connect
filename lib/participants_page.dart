import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParticipantsPage extends StatefulWidget {
  final int eventId;

  const ParticipantsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {

  Future<List<Map<String, dynamic>>> fetchParticipants() async {
    final response = await Supabase.instance.client
        .from('registrations')
        .select()
        .eq('event_id', widget.eventId);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),

      appBar: AppBar(
        backgroundColor: const Color(0xff0D1028),
        title: const Text(
          "Participants",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchParticipants(),
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

          final participants = snapshot.data ?? [];

          if (participants.isEmpty) {
            return const Center(
              child: Text(
                "No Participants Yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: participants.length,
            itemBuilder: (context, index) {

              final student = participants[index];

              return Card(
                color: const Color(0xff202744),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(bottom: 18),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        student['name'] ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      info(Icons.school,
                          "College",
                          student['college']),

                      info(Icons.menu_book,
                          "Department",
                          student['department']),

                      info(Icons.calendar_today,
                          "Year",
                          student['year'].toString()),

                      info(Icons.location_city,
                          "City",
                          student['city']),

                      info(Icons.map,
                          "State",
                          student['state']),

                      info(Icons.email,
                          "Email",
                          student['email']),

                      info(Icons.phone,
                          "Phone",
                          student['phone']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget info(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.deepPurpleAccent,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              "$title : ${value ?? ''}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}