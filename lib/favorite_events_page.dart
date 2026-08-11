import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'event_card.dart';

class FavoriteEventsPage extends StatefulWidget {
  const FavoriteEventsPage({super.key});

  @override
  State<FavoriteEventsPage> createState() => _FavoriteEventsPageState();
}

class _FavoriteEventsPageState extends State<FavoriteEventsPage> {

Future<List<Map<String, dynamic>>> fetchFavorites() async {

final user = Supabase.instance.client.auth.currentUser;

if (user == null) {
return [];
}

final response = await Supabase.instance.client
    .from('favorites')
    .select('''
      event_id,
      events!favorites_event_id_fkey(
        id,
        title,
        college,
        category,
        city,
        state,
        date,
        seats,
        map_link
      )
    ''')
    .eq('user_id', user.id);

return List<Map<String, dynamic>>.from(response);
}
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF1C2147),

appBar: AppBar(
backgroundColor: const Color(0xFF0E1325),
title: const Text("Favorite Events"),
),

body: FutureBuilder<List<Map<String, dynamic>>>(
future: fetchFavorites(),
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

final favorites = snapshot.data ?? [];

if (favorites.isEmpty) {
return const Center(
child: Text(
"No Favorite Events Yet ❤️",
style: TextStyle(
color: Colors.white,
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
);
}
return ListView.builder(
  padding: const EdgeInsets.all(20),
  itemCount: favorites.length,
  itemBuilder: (context, index) {

    final event = favorites[index]['events'];
    return EventCard(
      eventId: event['id'],
      category: event['category'] ?? "",
      title: event['title'] ?? "",
      college: event['college'] ?? "",
      location: "${event['city']}, ${event['state']}",
      date: event['date'].toString(),
      seats: event['seats'].toString(),
      description: "",
      mapLink: event['map_link'] ?? "",
      onFavoriteRemoved: () {
        setState(() {});
      },
    );

  },
);
},
),
);
}
}