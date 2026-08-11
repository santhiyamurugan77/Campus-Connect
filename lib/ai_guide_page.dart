import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ai_engine.dart';
class AIGuidePage extends StatefulWidget {
  const AIGuidePage({super.key});

  @override
  State<AIGuidePage> createState() => _AIGuidePageState();
}

class _AIGuidePageState extends State<AIGuidePage> {
  bool isTyping = false;
  final TextEditingController controller = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      "sender": "ai",
      "text":
      "👋 Hi! I'm CampusConnect AI.\n\nTell me your department, skills or career goal and I'll recommend suitable events."
    }
  ];

  Future<void> sendMessage() async {
    String question = controller.text.trim();

    if (question.isEmpty) return;

    setState(() {
      messages.add({
        "sender": "user",
        "text": question,
      });

      isTyping = true;
    });

    controller.clear();

    String? aiReply = AIEngine.getResponse(question);

    List<String> categories =
    AIEngine.recommendCategories(question);

    String? city = AIEngine.detectCity(question);

    String answer = "";

    if (aiReply != null) {
      answer += "$aiReply\n\n";
    }

    if (categories.isNotEmpty) {

      answer += "🎯 Recommended Categories\n\n";

      for (String category in categories) {
        answer += "• $category\n";
      }

      answer += "\n📅 Available Events\n\n";

      bool found = false;

      for (String category in categories) {

        dynamic query = Supabase.instance.client
            .from('events')
            .select()
            .eq('category', category);

        if (city != null) {
          query = query.eq('city', city);
        }

        final events = await query;

        for (final event in events) {

          found = true;

          answer +=
          "✅ ${event['title']}\n"
              "🏫 ${event['college']}\n"
              "📍 ${event['city']}, ${event['state']}\n"
              "📅 ${event['date']}\n\n";
        }
      }

      if (!found) {
        answer +=
        "No matching events are available right now.\n\n"
            "Please check again later.";
      }

    }

    if (answer.isEmpty) {
      answer =
      "🤖 Sorry, I couldn't understand your question.\n\n"
          "Try asking:\n"
          "• AI\n"
          "• Flutter\n"
          "• Placement\n"
          "• CSE\n"
          "• Hackathon\n"
          "• Workshops in Chennai";
    }

    await Future.delayed(const Duration(seconds: 2));

    setState(() {

      isTyping = false;

      messages.add({
        "sender": "ai",
        "text": answer,
      });

    });
  }

  Widget chatBubble(Map<String, String> message) {
    bool isUser = message["sender"] == "user";

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.deepPurpleAccent
              : const Color(0xff1B2342),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message["text"]!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.4,
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
        backgroundColor: const Color(0xff0D1028),
        elevation: 0,
        title: const Text("CampusConnect AI"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...messages.map((message) => chatBubble(message)).toList(),

                if (isTyping)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xff1B2342),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "CampusConnect AI is typing...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            color: const Color(0xff1B2342),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle:
                      TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),

                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.deepPurpleAccent,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}