class StudentModel {
  final String? id;
  final String name;
  final String email;
  final String? currentYear;
  final String? major;
  final List<String>? skills;

  StudentModel({
    this.id,
    required this.name,
    required this.email,
    this.currentYear,
    this.major,
    this.skills,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      "data": {
        "name": name,
        "email": email,
        "current_year": currentYear,
        "major": major,
        "skills": skills ?? [],
      }
    };
    if (id != null) {
      map["id"] = id!;
    }
    return map;
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      currentYear: json["current_year"],
      major: json["major"],
      skills: json["skills"] != null
          ? List<String>.from(json["skills"])
          : [],
    );
  }
}