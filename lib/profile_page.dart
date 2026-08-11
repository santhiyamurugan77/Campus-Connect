import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) return;

      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Widget profileTile(String title, String value) {
    return Card(
      color: const Color(0xff1B2342),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111633),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xff0D1028),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : profile == null
          ? const Center(
        child: Text(
          "No Profile Found",
          style: TextStyle(color: Colors.white),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            profileTile(
              "Full Name",
              profile!["full_name"] ?? "",
            ),

            profileTile(
              "College",
              profile!["college"] ?? "",
            ),

            profileTile(
              "Department",
              profile!["department"] ?? "",
            ),

            profileTile(
              "Year",
              profile!["year"] ?? "",
            ),

            profileTile(
              "Phone",
              profile!["phone"] ?? "",
            ),
          ],
        ),
      ),
    );
  }
}