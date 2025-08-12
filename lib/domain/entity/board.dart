class Board {
  String id;
  String name;
  String description;
  String? imageUrl;
  String? backgroundColor;
  DateTime? updatedAt;

  Board({required this.id, required this.name, required this.description, this.imageUrl, this.backgroundColor, this.updatedAt});

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['icon_url'] ?? "",
      backgroundColor: json['background_color'] ?? "",
      updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
    );
  }

  factory Board.fromRow(Map<String, dynamic> row) {
    return Board(
      id: row['id'],
      name: row['name'],
      description: row['description'],
      imageUrl: row['icon_url'] ?? "",
      backgroundColor: row['background_color'] ?? "",
      updatedAt: row["updated_at"] != null ? DateTime.parse(row["updated_at"]) : DateTime.now(),
    );
  }
}