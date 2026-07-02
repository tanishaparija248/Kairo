class ApiConstants {
  // Base URL
  static const String baseUrl = "https://api.lemma.work";

  // Pod ID
  static const String podId =
      "019eff70-5adb-7729-affd-f9afb35cbb5b";

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Polling
  static const Duration workflowPollInterval =
  Duration(seconds: 10);

  // Workflow Names
  static const String fullAnalysisWorkflow =
      "full-analysis";

  static const String evaluateWorkflow =
      "evaluate-response";

  // Tables
  static const String studentsTable = "students";
  static const String analysesTable = "job_analyses";
  static const String roadmapTable = "roadmaps";
  static const String questionsTable =
      "interview_questions";
  static const String responsesTable =
      "interview_responses";
}