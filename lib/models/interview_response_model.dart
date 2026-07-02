class InterviewResponseModel {
  final String id;
  final int? score;
  final String? feedback;
  final List<dynamic>? strengths;
  final List<dynamic>? weaknesses;
  final String status;

  InterviewResponseModel({
    required this.id,
    this.score,
    this.feedback,
    this.strengths,
    this.weaknesses,
    required this.status,
  });

  factory InterviewResponseModel.fromJson(
      Map<String, dynamic> json) {
    return InterviewResponseModel(
      id: json["id"],
      score: json["score"],
      feedback: json["feedback"],
      strengths: json["strengths"],
      weaknesses: json["weaknesses"],
      status: json["status"],
    );
  }
}