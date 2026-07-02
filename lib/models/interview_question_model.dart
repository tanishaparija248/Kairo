class InterviewQuestionModel {
  final String id;
  final String questionText;
  final String category;
  final String difficulty;
  final List<dynamic> expectedSkills;

  InterviewQuestionModel({
    required this.id,
    required this.questionText,
    required this.category,
    required this.difficulty,
    required this.expectedSkills,
  });

  factory InterviewQuestionModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = (json["data"] is Map) ? json["data"] : json;

    return InterviewQuestionModel(
      id: json["id"]?.toString() ?? "",
      questionText: data["question_text"]?.toString() ?? "",
      category: data["category"]?.toString() ?? "",
      difficulty: data["difficulty"]?.toString() ?? "",
      expectedSkills: data["expected_skills"] is List ? data["expected_skills"] : [],
    );
  }
}
