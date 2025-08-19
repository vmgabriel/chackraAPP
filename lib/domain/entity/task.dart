import 'dart:convert';

enum PriorityType {
  LOW,
  MEDIUM,
  HIGH,
  CRITICAL,
}

enum TaskStatus {
  TODO,
  DOING,
  DONE,
  ABANDONED,
}


class Task {
  String id;
  String name;
  String boardId;
  String description;
  PriorityType priority;
  TaskStatus status;
  String? iconUrl;
  Map<String, String> owner;
  DateTime? updatedAt;

  Task({
    required this.id,
    required this.name,
    required this.boardId,
    required this.description,
    required this.priority,
    required this.status,
    required this.owner,
    required this.updatedAt,
    this.iconUrl,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      name: json["name"],
      boardId: json["board_id"],
      description: json["description"],
      priority: PriorityType.values.firstWhere((element) => element.name.toLowerCase() == json["priority"].toLowerCase()),
      status: TaskStatus.values.firstWhere((element) => element.name.toLowerCase() == json["status"].toLowerCase()),
      updatedAt: json.containsKey("updated_at") ? DateTime.parse(json["updated_at"]) : DateTime.now(),
      owner: json.containsKey("owner_data") ? (json["owner_data"] as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())) : {},
      iconUrl: json["icon_url"] ?? "",
    );
  }

  factory Task.fromRow(Map<String, dynamic> row) {
    return Task(
      id: row["id"],
      name: row["name"],
      boardId: row["board_id"],
      description: row["description"],
      priority: PriorityType.values.firstWhere((element) => element.name.toLowerCase() == row["priority"].toLowerCase()),
      status: TaskStatus.values.firstWhere((element) => element.name.toLowerCase() == row["status"].toLowerCase()),
      updatedAt: row.containsKey("updated_at") ? DateTime.parse(row["updated_at"]) : DateTime.now(),
      owner: row.containsKey("owner") ? (json.decode(row["owner"]) as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())) : {},
      iconUrl: row["icon_url"] ?? "",
    );
  }
}