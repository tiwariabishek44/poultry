// my_calendar_response.dart

class MyCalendarResponse {
  final String? eventId;
  final String title; // Event title
  final String description; // Event description
  final String yearMonth; // Format: "YYYY-MM" (e.g., "2081-01")
  final String date; // Format: "YYYY-MM-DD" (e.g., "2081-01-15")
  final String adminId; // Farm owner ID
  final bool isComplete; // Event completion status

  MyCalendarResponse({
    this.eventId,
    required this.title,
    required this.description,
    required this.yearMonth,
    required this.date,
    required this.adminId,
    required this.isComplete,
  });

  factory MyCalendarResponse.fromJson(Map<String, dynamic> json,
      {String? eventId}) {
    return MyCalendarResponse(
      eventId: eventId ?? json['eventId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      yearMonth: json['yearMonth'] ?? '',
      date: json['date'] ?? '',
      adminId: json['adminId'] ?? '',
      isComplete: json['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'yearMonth': yearMonth,
      'date': date,
      'adminId': adminId,
      'isComplete': isComplete,
    };
  }
}
