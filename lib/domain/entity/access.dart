class AccessToken {
  String accessToken;
  String refreshToken;
  String type;
  DateTime expirationToken;

  AccessToken({
    required this.accessToken,
    required this.refreshToken,
    required this.type,
    required this.expirationToken
  });

  String get token => "$type $accessToken";

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        type: json["type"],
        expirationToken: DateTime.parse(json["expiration_datetime"])
    );
  }

  factory AccessToken.fromRow(Map<String, dynamic> row) {
    return AccessToken(
        accessToken: row["access_token"],
        refreshToken: row["refresh_token"],
        type: row["type"],
        expirationToken: row["expiration_datetime"]
    );
  }

  bool isExpired() {
    DateTime now = DateTime.now();
    return expirationToken.isAfter(now);
  }
}


enum LoginResponseType {
  LoginSuccess,
  ServerConnection,
  DataNotValid,
}

enum CreateResponseType {
  CreatedSuccess,
  UsernameAlreadyExists,
  EmailAlreadyExists,
  ServerConnection,
  DataNotValid,
}