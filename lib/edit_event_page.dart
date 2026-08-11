import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_event_page.dart';

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EditEventPage({
    super.key,
    required this.event,
  });

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
late TextEditingController titleController;
late TextEditingController collegeController;
late TextEditingController stateController;
late TextEditingController cityController;
late TextEditingController dateController;
late TextEditingController seatsController;
late TextEditingController descriptionController;
late TextEditingController mapController;

String? category;

final List<String> categories = [
"TECH",
"WORKSHOP",
"HACKATHON",
"SEMINAR",
"SPORTS",
"CULTURAL",
];

@override
void initState() {
super.initState();

titleController =
TextEditingController(text: widget.event["title"] ?? "");

collegeController =
TextEditingController(text: widget.event["college"] ?? "");

stateController =
TextEditingController(text: widget.event["state"] ?? "");

cityController =
TextEditingController(text: widget.event["city"] ?? "");

dateController =
TextEditingController(text: widget.event["date"] ?? "");

seatsController =
TextEditingController(
text: widget.event["seats"].toString(),
);

descriptionController =
TextEditingController(
text: widget.event["description"] ?? "",
);

mapController =
TextEditingController(
text: widget.event["map_link"] ?? "",
);

category = widget.event["category"];
}

@override
void dispose() {
titleController.dispose();
collegeController.dispose();
stateController.dispose();
cityController.dispose();
dateController.dispose();
seatsController.dispose();
descriptionController.dispose();
mapController.dispose();
super.dispose();
}

Future<void> updateEvent() async {
try {
await Supabase.instance.client
.from("events")
.update({
"title": titleController.text.trim(),
"college": collegeController.text.trim(),
"state": stateController.text.trim(),
"city": cityController.text.trim(),
"category": category,
"date": dateController.text.trim(),
"description":
descriptionController.text.trim(),
"map_link": mapController.text.trim(),
"seats":
int.parse(seatsController.text.trim()),
}).eq("id", widget.event["id"]);

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
"Event Updated Successfully",
),
),
);

Navigator.pop(context, true);
} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(e.toString()),
),
);
}
}
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xff111633),

appBar: AppBar(
backgroundColor: const Color(0xff0D1028),
elevation: 0,
title: const Text(
"Edit Event",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: SingleChildScrollView(
padding: const EdgeInsets.all(20),
child: Column(
children: [

TextField(
controller: titleController,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "Event Title",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 18),

TextField(
controller: collegeController,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "College",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 18),

TextField(
controller: stateController,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "State",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 18),

TextField(
controller: cityController,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "City",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 18),

DropdownButtonFormField<String>(
value: category,
dropdownColor: const Color(0xff1B2342),
decoration: const InputDecoration(
labelText: "Category",
labelStyle: TextStyle(color: Colors.white70),
),
items: categories
.map(
(item) => DropdownMenuItem(
value: item,
child: Text(item),
),
)
.toList(),
onChanged: (value) {
setState(() {
category = value;
});
},
),

const SizedBox(height: 18),

TextField(
controller: dateController,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "Event Date",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 18),

TextField(
controller: seatsController,
keyboardType: TextInputType.number,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "Available Seats",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 18),

TextField(
controller: descriptionController,
style: const TextStyle(color: Colors.white),
maxLines: 5,
decoration: const InputDecoration(
labelText: "Description",
labelStyle: TextStyle(color: Colors.white70),
alignLabelWithHint: true,
),
),

const SizedBox(height: 18),

TextField(
controller: mapController,
style: const TextStyle(color: Colors.white),
decoration: const InputDecoration(
labelText: "Google Map Link",
labelStyle: TextStyle(color: Colors.white70),
),
),

const SizedBox(height: 30),
  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      onPressed: updateEvent,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: const Icon(Icons.save),
      label: const Text(
        "UPDATE EVENT",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),

],
),
),
);
}
}