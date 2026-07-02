class WorkflowRunModel {
  final String id;
  final String status;
  final String? currentNodeId;
  final List<dynamic>? stepHistory;
  final String? error;

  WorkflowRunModel({
    required this.id,
    required this.status,
    this.currentNodeId,
    this.stepHistory,
    this.error,
  });

  factory WorkflowRunModel.fromJson(Map<String, dynamic> json) {
    // Lemma sometimes returns the run object directly, sometimes nested
    final Map<String, dynamic> data = json.containsKey("status") 
        ? json 
        : (json["data"] is Map ? json["data"] : json);

    return WorkflowRunModel(
      id: data["id"]?.toString() ?? "",
      status: data["status"]?.toString() ?? "UNKNOWN",
      currentNodeId: data["current_node_id"]?.toString(),
      stepHistory: data["step_history"] is List ? data["step_history"] : null,
      error: data["error"]?.toString(),
    );
  }
}
