import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FindEventsPage extends StatefulWidget {
  const FindEventsPage({super.key});

  @override
  State<FindEventsPage> createState() => _FindEventsPageState();
}

class _FindEventsPageState extends State<FindEventsPage> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];

  // States will be loaded automatically from Supabase events.
  List<String> availableStates = ["All States"];

  bool isLoading = true;

  String selectedState = "All States";
  String selectedCategory = "All Types";

  @override
  void initState() {
    super.initState();

    loadEvents();

    searchController.addListener(() {
      filterEvents();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // LOAD EVENTS + AUTOMATICALLY CREATE STATE LIST
  // ------------------------------------------------------------

  Future<void> loadEvents() async {
    try {
      final data = await Supabase.instance.client
          .from('events')
          .select()
          .order('id', ascending: false);

      allEvents = List<Map<String, dynamic>>.from(data);

      filteredEvents = List.from(allEvents);

      // ----------------------------------------------------------
      // Get unique states from the events table
      // ----------------------------------------------------------

      final Map<String, String> stateMap = {};

      for (final event in allEvents) {
        final stateValue = event['state'];

        if (stateValue != null) {
          final originalState = stateValue.toString().trim();

          if (originalState.isNotEmpty) {
            final key = originalState
                .toLowerCase()
                .replaceAll(RegExp(r'[\s_-]+'), '');

            // Standardize Tamil Nadu
            if (key == 'tamilnadu') {
              stateMap[key] = 'Tamil Nadu';
            } else {
              stateMap[key] = originalState;
            }
          }
        }
      }

      final states = stateMap.values.toList();

      states.sort(
            (a, b) => a.toLowerCase().compareTo(
          b.toLowerCase(),
        ),
      );

      availableStates = [
        "All States",
        ...states,
      ];

      // Make sure selected state still exists.
      if (!availableStates.contains(selectedState)) {
        selectedState = "All States";
      }
    } catch (e) {
      debugPrint("Error loading events: $e");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ------------------------------------------------------------
  // FILTER EVENTS
  // ------------------------------------------------------------

  void filterEvents() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      filteredEvents = allEvents.where((event) {
        final title =
        (event['title'] ?? '').toString().toLowerCase();

        final college =
        (event['college'] ?? '').toString().toLowerCase();

        final city =
        (event['city'] ?? '').toString().toLowerCase();

        final state = (event['state'] ?? '')
            .toString()
            .trim()
            .toLowerCase()
            .replaceAll(RegExp(r'[\s_-]+'), '');

        final selectedStateKey = selectedState
            .trim()
            .toLowerCase()
            .replaceAll(RegExp(r'[\s_-]+'), '');

        final category =
        (event['category'] ?? '').toString();

        final searchMatch =
            title.contains(query) ||
                college.contains(query) ||
                city.contains(query);

        final stateMatch =
            selectedState == "All States" ||
                state == selectedStateKey;


        final categoryMatch =
            selectedCategory == "All Types" ||
                category == selectedCategory;

        return searchMatch &&
            stateMatch &&
            categoryMatch;
      }).toList();
    });
  }

  // ------------------------------------------------------------
  // SUGGESTION CHIP
  // ------------------------------------------------------------

  Widget suggestionChip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(text),
        onPressed: () {
          searchController.text = text;
          filterEvents();
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff151B34),

      appBar: AppBar(
        backgroundColor: const Color(0xff11182F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Find Events",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ------------------------------------------------
            // SEARCH BAR
            // ------------------------------------------------

            TextField(
              controller: searchController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText:
                "Search event, college or city",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: const Color(0xff252D43),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // SUGGESTION CHIPS
            // ------------------------------------------------

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  suggestionChip("Dance"),
                  suggestionChip("Workshop"),
                  suggestionChip("Hackathon"),
                  suggestionChip("Sports"),
                  suggestionChip("Conference"),
                  suggestionChip("Music"),
                  suggestionChip(
                      "Paper Presentation"),
                  suggestionChip("Tech Quiz"),
                  suggestionChip("Symposium"),
                  suggestionChip("Seminar"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // FILTERS
            // ------------------------------------------------

            Row(
              children: [

                // ============================================
                // DYNAMIC STATE DROPDOWN
                // ============================================

                Expanded(
                  child:
                  DropdownButtonFormField<String>(
                    isExpanded: true,

                    value: selectedState,

                    dropdownColor:
                    const Color(0xff252D43),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                      const Color(0xff252D43),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),

                    items: availableStates.map(
                          (state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child: Text(
                            state,
                            overflow:
                            TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedState = value;
                      });

                      filterEvents();
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // ============================================
                // CATEGORY DROPDOWN
                // ============================================

                Expanded(
                  child:
                  DropdownButtonFormField<String>(
                    isExpanded: true,

                    value: selectedCategory,

                    dropdownColor:
                    const Color(0xff252D43),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                      const Color(0xff252D43),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: "All Types",
                        child: Text("All Types"),
                      ),
                      DropdownMenuItem(
                        value: "TECH",
                        child: Text("TECH"),
                      ),
                      DropdownMenuItem(
                        value: "WORKSHOP",
                        child: Text("WORKSHOP"),
                      ),
                      DropdownMenuItem(
                        value: "SPORTS",
                        child: Text("SPORTS"),
                      ),
                      DropdownMenuItem(
                        value: "HACKATHON",
                        child: Text("HACKATHON"),
                      ),
                      DropdownMenuItem(
                        value: "SEMINAR",
                        child: Text("SEMINAR"),
                      ),
                      DropdownMenuItem(
                        value: "CULTURAL",
                        child: Text("CULTURAL"),
                      ),
                    ],

                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedCategory = value;
                      });

                      filterEvents();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // EVENT COUNT
            // ------------------------------------------------

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${filteredEvents.length} Events Found",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ------------------------------------------------
            // EVENTS LIST
            // ------------------------------------------------

            Expanded(
              child: filteredEvents.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [

                    Icon(
                      Icons.search_off,
                      color: Colors.white54,
                      size: 80,
                    ),

                    SizedBox(height: 15),

                    Text(
                      "No Events Found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Try another search or filter.",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount:
                filteredEvents.length,

                itemBuilder:
                    (context, index) {

                  final event =
                  filteredEvents[index];

                  return Card(
                    color:
                    const Color(0xff1F2740),

                    margin:
                    const EdgeInsets.only(
                      bottom: 15,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                        16,
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          // CATEGORY
                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),

                            decoration:
                            BoxDecoration(
                              color:
                              Colors.deepPurple,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                20,
                              ),
                            ),

                            child: Text(
                              event["category"]
                                  ?.toString() ??
                                  "",
                              style:
                              const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          // TITLE
                          Text(
                            event["title"]
                                ?.toString() ??
                                "",
                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          // COLLEGE
                          Text(
                            event["college"]
                                ?.toString() ??
                                "",
                            style:
                            const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          // LOCATION
                          Row(
                            children: [

                              const Icon(
                                Icons.location_on,
                                color:
                                Colors.redAccent,
                                size: 18,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Expanded(
                                child: Text(
                                  "${event["city"] ?? ""}, ${event["state"] ?? ""}",
                                  style:
                                  const TextStyle(
                                    color: Colors
                                        .white70,
                                  ),
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          // DATE + SEATS
                          Row(
                            children: [

                              const Icon(
                                Icons
                                    .calendar_today,
                                color:
                                Colors.white70,
                                size: 18,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(
                                event["date"]
                                    ?.toString() ??
                                    "",
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white70,
                                ),
                              ),

                              const Spacer(),

                              const Icon(
                                Icons.event_seat,
                                color:
                                Colors.white70,
                                size: 18,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(
                                "${event["seats"] ?? 0} Seats",
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          // BUTTONS
                          Row(
                            children: [

                              Expanded(
                                child:
                                ElevatedButton
                                    .icon(
                                  style:
                                  ElevatedButton
                                      .styleFrom(
                                    backgroundColor:
                                    Colors
                                        .deepPurple,
                                  ),

                                  onPressed: () {},

                                  icon: const Icon(
                                    Icons
                                        .app_registration,
                                  ),

                                  label:
                                  const Text(
                                    "Register",
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Expanded(
                                child:
                                OutlinedButton
                                    .icon(
                                  onPressed: () {},

                                  icon: const Icon(
                                    Icons
                                        .map_outlined,
                                  ),

                                  label:
                                  const Text(
                                    "Map",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}