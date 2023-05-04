class EcorecoveryWorkshop {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startTime;
  final DateTime endTime;
  final String meetupPoint;
  final String description;
  final List<String> organizers;
  final List<String> attendees;
  final List<Instruction> instructions;
  final List<Objective> objectives;

  EcorecoveryWorkshop({
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
    required this.objectives,
  });

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
      'attendees': attendees,
      'instructions': instructions.map((instruction) => instruction.toJson()).toList(),
      'objectives': objectives.map((objective) => objective.toJson()).toList(),
    };
  }

  factory EcorecoveryWorkshop.fromJson(Map<String, dynamic> json) {
    return EcorecoveryWorkshop(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      meetupPoint: json['meetup_point'],
      description: json['description'],
      organizers: List<String>.from(json['organizers']),
      attendees: List<String>.from(json['attendees']),
      instructions: List<Instruction>.from(
        json['instructions'].map((instruction) => Instruction.fromJson(instruction)),
      ),
      objectives: List<Objective>.from(
        json['objectives'].map((objective) => Objective.fromJson(objective)),
      ),
    );
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'sequence': sequence,
    };
  }

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      id: json['id'],
      description: json['description'],
      sequence: json['sequence'],
    );
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'sequence': sequence,
      'is_achieved': isAchieved,
    };
  }

  factory Objective.fromJson(Map<String, dynamic> json) {
    return Objective(
      id: json['id'],
      description: json['description'],
      sequence: json['sequence'],
      isAchieved: json['is_achieved'],
    );
  }
}
