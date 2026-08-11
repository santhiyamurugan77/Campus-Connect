import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_event_page.dart';
import 'participants_page.dart';
import 'edit_event_page.dart';

class OrganizerPage extends StatefulWidget {
  const OrganizerPage({super.key});

  @override
  State<OrganizerPage> createState() => _OrganizerPageState();
}

class _OrganizerPageState extends State<OrganizerPage> {

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return [];

    final data = await Supabase.instance.client
        .from('events')
        .select()
        .eq('organizer_id', user.id)
        .order('id', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<int> getEventCount() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return 0;

    final events = await Supabase.instance.client
        .from('events')
        .select('id')
        .eq('organizer_id', user.id);

    return events.length;
  }

  Future<int> getParticipantCount() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return 0;

    final myEvents = await Supabase.instance.client
        .from('events')
        .select('id')
        .eq('organizer_id', user.id);

    if (myEvents.isEmpty) return 0;

    final eventIds = myEvents.map((e) => e['id']).toList();

    final registrations = await Supabase.instance.client
        .from('registrations')
        .select('event_id')
        .inFilter('event_id', eventIds);

    return registrations.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0D1028),
        centerTitle: true,
        title: const Text(
          "Organizer Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurpleAccent,
        icon: const Icon(Icons.add),
        label: const Text("Create Event"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateEventPage(),
            ),
          );

          setState(() {});
        },
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
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final events = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff5B4BFF),
                        Color(0xff8E54E9),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Text(
                              "Welcome Organizer 👋",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Manage your college events easily",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.event_available,
                        color: Colors.white,
                        size: 70,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [

                    Expanded(
                      child: FutureBuilder<int>(
                        future: getEventCount(),
                        builder: (context, snapshot) {
                          return buildCard(
                            Icons.event,
                            snapshot.data?.toString() ?? "0",
                            "Events",
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: FutureBuilder<int>(
                        future: getParticipantCount(),
                        builder: (context, snapshot) {
                          return buildCard(
                            Icons.people,
                            snapshot.data?.toString() ?? "0",
                            "Participants",
                          );
                        },
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "My Events",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                if (events.isEmpty)
                  const Center(
                    child: Text(
                      "No Events Created",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  )
                else
                  ...events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: eventCard(
                        context: context,
                        event: event,
                      ),
                    );
                  }),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildCard(IconData icon,
      String number,
      String title,) {
    return Container(
      height: 145,
      decoration: BoxDecoration(
        color: const Color(0xff1B2342),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            Colors.deepPurple.withValues(alpha: 0.2),
            child: Icon(
              icon,
              color: Colors.deepPurpleAccent,
              size: 28,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            number,
            style: const TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget eventCard({
    required BuildContext context,
    required Map<String, dynamic> event,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1B2342),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              event["category"].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
           event["title"].toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.school,
                color: Colors.white54,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event["college"].toString(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Colors.white54,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                event["date"].toString(),
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.confirmation_number,
                color: Colors.white54,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "${event["seats"]} Seats Left",
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ParticipantsPage(
                          eventId: event["id"],
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text("View Participants"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditEventPage(
                          event: event,
                        ),
                      ),
                    );

                    if (updated == true && mounted) {
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Event"),
                          content: const Text(
                            "Are you sure you want to delete this event?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm != true) return;

                    await Supabase.instance.client
                        .from('events')
                        .delete()
                        .eq('id', event["id"]);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Event deleted successfully"),
                      ),
                    );

                    setState(() {});
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}