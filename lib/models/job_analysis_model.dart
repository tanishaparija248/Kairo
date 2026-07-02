class JobAnalysisModel {
  final String? id;
  final String studentId;
  final String jdRaw;

  final String? roleTitle;
  final String? company;
  final String? jdSummary;
  final String? status;
  final List<dynamic>? extractedSkills;
  final Map<String, dynamic>? readinessData;

  JobAnalysisModel({
    this.id,
    required this.studentId,
    required this.jdRaw,
    this.roleTitle,
    this.company,
    this.jdSummary,
    this.status,
    this.extractedSkills,
    this.readinessData,
  });

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "student_id": studentId,
        "jd_raw": jdRaw,
      }
    };
  }

  factory JobAnalysisModel.fromJson(Map<String, dynamic> json) {
    // Lemma datastore records often nest fields inside "data"
    final Map<String, dynamic> data = (json["data"] is Map) ? json["data"] : json;
    
    return JobAnalysisModel(
      id: json["id"]?.toString(),
      studentId: data["student_id"]?.toString() ?? data["student"]?.toString() ?? "",
      jdRaw: data["jd_raw"]?.toString() ?? data["jd_text"]?.toString() ?? "",
      roleTitle: data["role_title"]?.toString(),
      company: data["company"]?.toString(),
      jdSummary: data["jd_summary"]?.toString(),
      status: data["status"]?.toString(),
      extractedSkills: data["extracted_skills"] is List ? data["extracted_skills"] : null,
      readinessData: data["readiness_data"] is Map ? data["readiness_data"] : null,
    );
  }
}
