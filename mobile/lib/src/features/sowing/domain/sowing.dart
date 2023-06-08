class SowingWorkshop {
  final String id;
  final String authorId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startTime;
  final DateTime endTime;
  final String meetupPoint;
  final String description;
  final List<String> organizers;
  final List<Attendee> attendees;
  final List<String> instructions;
  final List<Seed> seeds;
  final List<Objective> objectives;

  SowingWorkshop({
    required this.id,
    required this.authorId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.startTime,
    required this.endTime,
    required this.meetupPoint,
    required this.description,
    required this.organizers,
    required this.attendees,
    required this.instructions,
    required this.seeds,
    required this.objectives,
  });

  factory SowingWorkshop.fromJson(Map<String, dynamic> json) {
    return SowingWorkshop(
      id: json['id'],
      authorId: json['author_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      meetupPoint: json['meetup_point'],
      description: json['description'],
      organizers: List<String>.from(json['organizers']),
      attendees: List<Attendee>.from(json['attendees'].map((x) => Attendee.fromJson(x))),
      instructions: List<String>.from(json['instructions']),
      seeds: List<Seed>.from(json['seeds'].map((x) => Seed.fromJson(x))),
      objectives: List<Objective>.from(json['objectives'].map((x) => Objective.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'meetup_point': meetupPoint,
      'description': description,
      'organizers': organizers,
      'attendees': attendees.map((x) => x.toJson()).toList(),
      'instructions': instructions,
      'seeds': seeds.map((x) => x.toJson()).toList(),
      'objectives': objectives.map((x) => x.toJson()).toList(),
    };
  }
}

class Attendee {
  final String id;
  final String sowingWorkshopId;
  final List<Seed> seeds;

  Attendee({
    required this.id,
    required this.sowingWorkshopId,
    required this.seeds,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      sowingWorkshopId: json['sowing_workshop_id'],
      seeds: List<Seed>.from(json['seeds'].map((x) => Seed.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sowing_workshop_id': sowingWorkshopId,
      'seeds': seeds.map((x) => x.toJson()).toList(),
    };
  }
}

class Seed {
  final String id;
  final String description;
  final String imageLink;
  final int availableAmount;

  Seed({
    required this.id,
    required this.description,
    required this.imageLink,
    required this.availableAmount,
  });

  factory Seed.fromJson(Map<String, dynamic> json) {
    return Seed(
      id: json['id'],
      description: json['description'],
      imageLink: json['image_link'],
      availableAmount: json['available_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image_link': imageLink,
      'available_amount': availableAmount,
    };
  }
}

class Objective {
  final String description;
  final bool isAchieved;

  Objective({
    required this.description,
    required this.isAchieved,
  });

  factory Objective.fromJson(Map<String, dynamic> json) {
    return Objective(
      description: json['description'],
      isAchieved: json['isAchieved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'isAchieved': isAchieved,
    };
  }
}
