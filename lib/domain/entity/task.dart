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

  Task({
    required this.id,
    required this.name,
    required this.boardId,
    required this.description,
    required this.priority,
    required this.status,
    required this.owner,
    this.iconUrl,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      name: json["name"],
      boardId: json["board_id"],
      description: json["description"],
      priority: PriorityType.values.firstWhere((element) => element.name == json["priority"]),
      status: TaskStatus.values.firstWhere((element) => element.name == json["status"]),
      owner: json["owner"],
      iconUrl: json["icon_url"] ?? "",
    );
  }

  factory Task.fromRow(Map<String, dynamic> row) {
    return Task(
      id: row["id"],
      name: row["name"],
      boardId: row["board_id"],
      description: row["description"],
      priority: PriorityType.values.firstWhere((element) => element.name == row["priority"]),
      status: TaskStatus.values.firstWhere((element) => element.name == row["status"]),
      owner: row["owner"],
      iconUrl: row["icon_url"] ?? "",
    );
  }
}