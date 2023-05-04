class Ecotour {
  String id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime startTime;
  DateTime endTime;
  String meetingPoint;
  String description;
  List<String> organizers;
  List<String> attendees;

  Ecotour({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.startTime,
    required this.endTime,
    required this.meetingPoint,
    required this.description,
    required this.organizers,
    required this.attendees,
  });

  factory Ecotour.fromJson(Map<String, dynamic> json) {
    return Ecotour(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      meetingPoint: json['meeting_point'],
      description: json['description'],
      organizers: List<String>.from(json['organizers']),
      attendees: List<String>.from(json['attendees']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'meeting_point': meetingPoint,
      'description': description,
      'organizers': organizers,
      'attendees': attendees,
    };
  }
}
