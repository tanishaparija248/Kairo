class RoadmapModel {
  final String id;
  final int weekNumber;
  final String? title;
  final String? description;

  RoadmapModel({
    required this.id,
    required this.weekNumber,
    this.title,
    this.description,
  });

  factory RoadmapModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = (json["data"] is Map) ? json["data"] : json;
    
    return RoadmapModel(
      id: json["id"]?.toString() ?? "",
      weekNumber: int.tryParse(data["week_number"]?.toString() ?? "0") ?? 0,
      title: data["title"]?.toString(),
      description: data["description"]?.toString(),
    );
  }
}
