import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyRegistrationsPage extends StatefulWidget {
  const MyRegistrationsPage({super.key});

  @override
  State<MyRegistrationsPage> createState() =>
      _MyRegistrationsPageState();
}

class _MyRegistrationsPageState
    extends State<MyRegistrationsPage> {

  Future<List<Map<String, dynamic>>> fetchRegistrations() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return [];

    final response = await Supabase.instance.client
        .from('registrations')
        .select('''
        id,
        event_id,
        events (
          title,
          college,
          state,
          city,
          category,
          date,
          seats
        )
      ''')
        .eq('user_id', user.id);
    debugPrint("REGISTRATIONS: $response");

    return List<Map<String, dynamic>>.from(response);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),

      appBar: AppBar(
        backgroundColor: const Color(0xff0D1028),
        title: const Text("My Registrations"),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRegistrations(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Registrations Yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            );
          }

          final registrations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: registrations.length,
            itemBuilder: (context, index) {

              final event =registrations[index]['events'];
              return Card(
                color: const Color(0xff1B2342),
                margin:
                const EdgeInsets.only(bottom: 15),

                child: ListTile(
                  title: Text(
                    event['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "${event['college']}\n"
                        "${event['city']}, ${event['state']}\n"
                        "${event['date']}",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      event['category'],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}