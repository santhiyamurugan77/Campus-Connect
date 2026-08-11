import 'ai_responses.dart';

class AIEngine {

  // Returns predefined AI responses
  static String? getResponse(String input) {
    input = input.toLowerCase();

    for (final key in AIResponses.responses.keys) {
      if (input.contains(key)) {
        return AIResponses.responses[key];
      }
    }

    return null;
  }

  // Detect city
  static String? detectCity(String input) {
    input = input.toLowerCase();

    if (input.contains("chennai")) return "Chennai";
    if (input.contains("salem")) return "Salem";
    if (input.contains("coimbatore")) return "Coimbatore";
    if (input.contains("madurai")) return "Madurai";
    if (input.contains("trichy")) return "Trichy";
    if (input.contains("erode")) return "Erode";
    if (input.contains("vellore")) return "Vellore";
    if (input.contains("tirunelveli")) return "Tirunelveli";

    return null;
  }

  // Recommend event categories
  static List<String> recommendCategories(String input) {
    input = input.toLowerCase();

    List<String> categories = [];

    // Departments
    if (input.contains("cse") ||
        input.contains("computer") ||
        input.contains("information technology") ||
        input.contains("it")) {
      categories.addAll(["TECH", "WORKSHOP", "HACKATHON"]);
    }

    if (input.contains("ece")) {
      categories.addAll(["TECH", "WORKSHOP", "SEMINAR"]);
    }

    if (input.contains("mechanical")) {
      categories.addAll(["WORKSHOP", "SEMINAR"]);
    }

    if (input.contains("civil")) {
      categories.add("SEMINAR");
    }

    // Technologies
    if (input.contains("ai") ||
        input.contains("artificial intelligence") ||
        input.contains("machine learning")) {
      categories.addAll(["TECH", "WORKSHOP"]);
    }

    if (input.contains("flutter")) {
      categories.add("WORKSHOP");
    }

    if (input.contains("python")) {
      categories.addAll(["TECH", "WORKSHOP"]);
    }

    if (input.contains("java")) {
      categories.addAll(["TECH", "WORKSHOP"]);
    }

    if (input.contains("cyber")) {
      categories.addAll(["SEMINAR", "WORKSHOP"]);
    }

    if (input.contains("cloud")) {
      categories.add("SEMINAR");
    }

    if (input.contains("iot")) {
      categories.add("WORKSHOP");
    }

    // Career
    if (input.contains("placement")) {
      categories.add("SEMINAR");
    }

    if (input.contains("internship")) {
      categories.add("SEMINAR");
    }

    // Event Types
    if (input.contains("hackathon")) {
      categories.add("HACKATHON");
    }

    if (input.contains("workshop")) {
      categories.add("WORKSHOP");
    }

    if (input.contains("symposium")) {
      categories.add("TECH");
    }

    if (input.contains("seminar")) {
      categories.add("SEMINAR");
    }

    if (input.contains("sports")) {
      categories.add("SPORTS");
    }

    if (input.contains("dance") ||
        input.contains("music") ||
        input.contains("cultural")) {
      categories.add("CULTURAL");
    }

    return categories.toSet().toList();
  }
}