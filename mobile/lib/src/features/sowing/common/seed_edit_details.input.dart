class SeedEditDetailsInput {
  final String? id;
  String description;
  String imageLink;
  int availableAmount;

  SeedEditDetailsInput({
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
      'available_amount': availableAmount,
    };
  }
}
