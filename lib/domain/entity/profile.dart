
class Profile{
  final String id;
  final String imageUrl;
  final String name;
  final String lastName;
  final String username;
  final String description;
  final String email;
  final DateTime updatedAt;
  final String? phone;

  Profile({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.lastName,
    required this.username,
    required this.description,
    required this.email,
    required this.updatedAt,
    this.phone,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        id: json["id"],
        imageUrl: json["icon_url"] ?? "",
        name: json["name"],
        lastName: json["last_name"],
        username: json["username"],
        description: json["description"] ?? "",
        email: json["email"],
        updatedAt: json.containsKey("updated_at") ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        phone: json["phone"] ?? ""
    );
  }

  factory Profile.fromRow(Map<String, dynamic> row) {
    return Profile(
        id: row["id"],
        imageUrl: row["image_url"] ?? "",
        name: row["name"],
        lastName: row["last_name"],
        username: row["username"],
        description: row["description"] ?? "",
        email: row["email"],
        updatedAt: row.containsKey("updated_at") ? DateTime.parse(row["updated_at"]) : DateTime.now(),
        phone: row["phone"] ?? ""
    );
  }

  String getId() {
    return email;
  }
}

class User extends Profile {
  final String password;
  final String repeatPassword;

  User({
    required super.id,
    required super.imageUrl,
    required super.name,
    required super.lastName,
    required super.username,
    required super.description,
    required super.email,
    required super.phone,
    required super.updatedAt,
    required this.password,
    required this.repeatPassword
  });
}