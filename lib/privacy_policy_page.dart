import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Widget buildSection(String title, String content) {
    return Card(
      color: const Color(0xff1B2342),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
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
          "Privacy Policy",
          style: TextStyle(fontWeight: FontWeight.bold),
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
                Icons.privacy_tip,
                color: Colors.white,
                size: 45,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "CampusConnect Privacy Policy",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            buildSection(
              "Information We Collect",
              "CampusConnect collects your basic profile information such as your name, email address, college, department, and event registrations to provide our services.",
            ),

            buildSection(
              "How We Use Your Information",
              "Your information is used to manage event registrations, personalize event recommendations, improve user experience, and communicate important event updates.",
            ),

            buildSection(
              "Data Security",
              "Your information is securely stored using Supabase. We use secure authentication and database protection to keep your personal information safe.",
            ),

            buildSection(
              "Data Sharing",
              "CampusConnect does not sell, rent, or share your personal information with third parties except when required by law or for essential application functionality.",
            ),

            buildSection(
              "Your Rights",
              "You can update your profile information, remove favorite events, manage notification preferences, or contact us regarding your personal data at any time.",
            ),

            buildSection(
              "Contact",
              "If you have any questions regarding this Privacy Policy, please contact the CampusConnect development team through the Contact Us page.",
            ),

            const SizedBox(height: 25),

            const Divider(color: Colors.white24),

            const SizedBox(height: 15),

            const Text(
              "Last Updated",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "August 2026",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

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
}