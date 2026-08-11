import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final titleController = TextEditingController();
  final collegeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final dateController = TextEditingController();
  final seatsController = TextEditingController();
  final mapLinkController = TextEditingController();

  String? selectedCategory;
  String? selectedState;

  final List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  final List<String> categories = [
    "TECH",
    "CULTURAL",
    "WORKSHOP",
    "SPORTS",
    "HACKATHON",
    "SEMINAR",
  ];

  @override
  void dispose() {
    titleController.dispose();
    collegeController.dispose();
    stateController.dispose();
    cityController.dispose();
    dateController.dispose();
    seatsController.dispose();
    mapLinkController.dispose();
    super.dispose();
  }

  Future<void> createEvent() async {
    final user = Supabase.instance.client.auth.currentUser;

    debugPrint("Current User: $user");

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You are not logged in"),
        ),
      );
      return;
    }

    if (titleController.text.trim().isEmpty ||
        collegeController.text.trim().isEmpty ||
        selectedState == null ||
        cityController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        seatsController.text.trim().isEmpty ||
        mapLinkController.text.trim().isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    final seats = int.tryParse(
      seatsController.text.trim(),
    );

    if (seats == null || seats <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid number of seats"),
        ),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('events').insert({
        'title': titleController.text.trim(),
        'college': collegeController.text.trim(),

        // Selected state is automatically saved to Supabase.
        'state': selectedState,

        'city': cityController.text.trim(),
        'category': selectedCategory,
        'date': dateController.text.trim(),
        'seats': seats,
        'map_link': mapLinkController.text.trim(),
        'organizer_id': user.id,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event Created Successfully"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create event: $e"),
        ),
      );
    }
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.white70,
      ),
      filled: true,
      fillColor: const Color(0xff1B2342),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.white12,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.deepPurpleAccent,
          width: 2,
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
          "Create Event",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // --------------------------------------------------
            // EVENT TITLE
            // --------------------------------------------------

            TextField(
              controller: titleController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: fieldDecoration(
                "Event Title",
              ),
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // COLLEGE
            // --------------------------------------------------

            TextField(
              controller: collegeController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: fieldDecoration(
                "College Name",
              ),
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // STATE DROPDOWN
            // --------------------------------------------------

            DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedState,

              dropdownColor: const Color(0xff252D43),

              decoration: fieldDecoration(
                "State",
              ),

              items: states.map(
                    (state) {
                  return DropdownMenuItem<String>(
                    value: state,

                    child: Text(
                      state,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ).toList(),

              onChanged: (value) {
                setState(() {
                  selectedState = value;

                  // Keep controller synchronized.
                  stateController.text = value ?? "";
                });
              },
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // CITY
            // --------------------------------------------------

            TextField(
              controller: cityController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: fieldDecoration(
                "City",
              ),
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // CATEGORY
            // --------------------------------------------------

            DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedCategory,

              dropdownColor: const Color(0xff252D43),

              decoration: fieldDecoration(
                "Category",
              ),

              items: categories.map(
                    (category) {
                  return DropdownMenuItem<String>(
                    value: category,

                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // EVENT DATE
            // --------------------------------------------------

            TextField(
              controller: dateController,
              readOnly: true,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: fieldDecoration(
                "Event Date",
              ).copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: Colors.white70,
                ),
              ),

              onTap: () async {
                final picked = await showDatePicker(
                  context: context,

                  initialDate: DateTime.now(),

                  firstDate: DateTime.now(),

                  lastDate: DateTime(2035),
                );

                if (picked != null) {
                  dateController.text =
                  picked.toIso8601String().split('T')[0];
                }
              },
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // AVAILABLE SEATS
            // --------------------------------------------------

            TextField(
              controller: seatsController,

              keyboardType: TextInputType.number,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: fieldDecoration(
                "Available Seats",
              ),
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // GOOGLE MAPS LINK
            // --------------------------------------------------

            TextField(
              controller: mapLinkController,

              keyboardType: TextInputType.url,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: fieldDecoration(
                "Google Maps Link",
              ).copyWith(
                hintText: "https://maps.google.com/...",
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------
            // CREATE EVENT BUTTON
            // --------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: createEvent,

                icon: const Icon(
                  Icons.add,
                ),

                label: const Text(
                  "CREATE EVENT",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.deepPurpleAccent,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}