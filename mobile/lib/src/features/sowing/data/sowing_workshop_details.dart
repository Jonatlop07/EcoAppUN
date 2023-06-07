class SowingWorkshopDetails {
  final String authorId;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String meetingPoint;
  final List<String> organizers;
  final List<String> instructions;
  final List<String> objectives;
  final List<SeedDetails> seeds;

  SowingWorkshopDetails({
    required this.authorId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.meetingPoint,
    required this.organizers,
    required this.instructions,
    required this.objectives,
    required this.seeds,
  });

  Map<String, dynamic> toJson() {
    return {
      'author_id': authorId,
      'title': title,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'meeting_point': meetingPoint,
      'organizers': organizers,
      'instructions': instructions,
      'objectives': objectives,
      'seeds': seeds.map((seed) => seed.toJson()).toList(),
    };
  }
}

class SeedDetails {
  final String? id;
  final String description;
  final String imageLink;
  final int availableAmount;

  SeedDetails({
    this.id,
    required this.description,
    required this.imageLink,
    required this.availableAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image_link': imageLink,
      'available_amount': availableAmount
    };
  }
}
