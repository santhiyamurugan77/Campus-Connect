import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  Future<void> launchLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Widget contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xff1B2342),
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(
            icon,
            color: Colors.white,
          ),
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
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 18,
        ),
        onTap: onTap,
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
          "Contact Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 45,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "CampusConnect Support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "We're here to help you!",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            contactCard(
              icon: Icons.email,
              title: "Email",
              subtitle: "campusconnect@gmail.com",
              onTap: () {
                launchLink(
                  "mailto:campusconnect@gmail.com",
                );
              },
            ),

            contactCard(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "9080668177",
              onTap: () {
                launchLink(
                  "tel:9080668177",
                );
              },
            ),

            contactCard(
              icon: Icons.location_on,
              title: "Location",
              subtitle: "Tamil Nadu, India",
              onTap: () {},
            ),

            const SizedBox(height: 25),

            const Card(
              color: Color(0xff1B2342),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  "CampusConnect is designed to help students discover, register, and participate in college events across different institutions.\n\nFor support, suggestions, or feedback, feel free to contact us using the email address or phone number above.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "© 2026 CampusConnect",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}