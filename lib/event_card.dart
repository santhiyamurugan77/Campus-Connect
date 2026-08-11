import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatefulWidget {
  final int eventId;
  final String category;
  final String title;
  final String college;
  final String location;
  final String date;
  final String seats;
  final String description;
  final String mapLink;

  final VoidCallback? onFavoriteRemoved;

  const EventCard({
    super.key,
    required this.eventId,
    required this.category,
    required this.title,
    required this.college,
    required this.location,
    required this.date,
    required this.seats,
    required this.description,
    required this.mapLink,
    this.onFavoriteRemoved,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  Future<void> checkFavorite() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    final data = await Supabase.instance.client
        .from('favorites')
        .select()
        .eq('user_id', user.id)
        .eq('event_id', widget.eventId);

    if (mounted) {
      setState(() {
        isFavorite = data.isNotEmpty;
      });
    }
  }

  Future<void> toggleFavorite() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    if (!isFavorite) {
      await Supabase.instance.client.from('favorites').insert({
        'user_id': user.id,
        'event_id': widget.eventId,
      });

      setState(() {
        isFavorite = true;
      });
    } else {
      await Supabase.instance.client
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('event_id', widget.eventId);

      setState(() {
        isFavorite = false;
      });
      if (widget.onFavoriteRemoved != null) {
        widget.onFavoriteRemoved!();
      }
    }
  }

  Future<void> openMap(BuildContext context) async {
    if (widget.mapLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Map link not available"),
        ),
      );
      return;
    }

    final url = Uri.parse(widget.mapLink);

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open Google Maps"),
        ),
      );
    }
  }
  Future<void> showRegistrationForm() async {
    final nameController = TextEditingController();
    final collegeController = TextEditingController();
    final departmentController = TextEditingController();
    final yearController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    Widget _buildField({
      required TextEditingController controller,
      required String label,
      required IconData icon,
      TextInputType keyboardType = TextInputType.text,
    }) {
      return TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white70,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.deepPurpleAccent,
          ),
          filled: true,
          fillColor: const Color(0xFF202744),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Colors.white24,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2,
            ),
          ),
        ),
      );
    }

    await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xFF111633),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Event Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                _buildField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: collegeController,
                  label: "College Name",
                  icon: Icons.school,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: departmentController,
                  label: "Department",
                  icon: Icons.menu_book,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: yearController,
                  label: "Year (1/2/3/4)",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: cityController,
                  label: "City",
                  icon: Icons.location_city,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: stateController,
                  label: "State",
                  icon: Icons.map,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                _buildField(
                  controller: phoneController,
                  label: "Phone Number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.deepPurpleAccent,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              collegeController.text.isEmpty ||
                              departmentController.text.isEmpty ||
                              yearController.text.isEmpty ||
                              cityController.text.isEmpty ||
                              stateController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              phoneController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all details"),
                              ),
                            );
                            return;
                          }

                          final user = Supabase.instance.client.auth.currentUser;

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please login first"),
                              ),
                            );
                            return;
                          }

                          try {
                            await Supabase.instance.client
                                .from('registrations')
                                .insert({
                              'user_id': user.id,
                              'event_id': widget.eventId,
                              'name': nameController.text.trim(),
                              'college': collegeController.text.trim(),
                              'department': departmentController.text.trim(),
                              'year': yearController.text.trim(),
                              'city': cityController.text.trim(),
                              'state': stateController.text.trim(),
                              'email': emailController.text.trim(),
                              'phone': phoneController.text.trim(),
                            });

                            print("✅ Registration Saved");

                            if (!mounted) return;

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registration Successful 🎉"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            print("❌ Registration Error: $e");

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF202744),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.category,
                  style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: toggleFavorite,
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "${widget.college}\n${widget.location}",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                widget.date,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.confirmation_num,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                "${widget.seats} Seats Left",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          if (widget.description.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              widget.description,
              style: const TextStyle(color: Colors.white70),
            ),
          ],

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => openMap(context),
                  icon: const Icon(Icons.map),
                  label: const Text("Map"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

    Expanded(
    child: ElevatedButton.icon(
    onPressed: () {
    showRegistrationForm();
    },
    icon: const Icon(Icons.app_registration),
    label: const Text("Register"),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurpleAccent,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
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