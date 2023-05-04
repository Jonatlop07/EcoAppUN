class SowingWorkshop {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startTime;
  final DateTime endTime;
  final String meetupPoint;
  final String description;
  final List<String> organizers;
  final List<Attendee> attendees;
  final List<Instruction> instructions;
  final List<Seed> seeds;
  final List<Objective> objectives;

  SowingWorkshop({
    required this.id,
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
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      meetupPoint: json['meetup_point'],
      description: json['description'],
      organizers: List<String>.from(json['organizers']),
      attendees: List<Attendee>.from(json['attendees'].map((x) => Attendee.fromJson(x))),
      instructions:
          List<Instruction>.from(json['instructions'].map((x) => Instruction.fromJson(x))),
      seeds: List<Seed>.from(json['seeds'].map((x) => Seed.fromJson(x))),
      objectives: List<Objective>.from(json['objectives'].map((x) => Objective.fromJson(x))),
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
      'meetup_point': meetupPoint,
      'description': description,
      'organizers': organizers,
      'attendees': attendees.map((x) => x.toJson()).toList(),
      'instructions': instructions.map((x) => x.toJson()).toList(),
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

class Instruction {
  final String id;
  final String description;
  final int sequence;

  Instruction({
    required this.id,
    required this.description,
    required this.sequence,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      id: json['id'],
      description: json['description'],
      sequence: json['sequence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'sequence': sequence,
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
  final String id;
  final String description;
  final int sequence;
  final bool isAchieved;

  Objective({
    required this.id,
    required this.description,
    required this.sequence,
    required this.isAchieved,
  });

  factory Objective.fromJson(Map<String, dynamic> json) {
    return Objective(
      id: json['id'],
      description: json['description'],
      sequence: json['sequence'],
      isAchieved: json['isAchieved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'sequence': sequence,
      'isAchieved': isAchieved,
    };
  }
}
