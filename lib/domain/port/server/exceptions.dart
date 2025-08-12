class CustomErrorClient implements Exception {
  String title;
  String description;

  CustomErrorClient({required this.title, required this.description});

  @override
  String toString() {
    return '{"title": "$title", "description": "$description"}';
  }
}


class NotValidErrorClient extends CustomErrorClient {
  NotValidErrorClient({required super.title, required super.description});
}


class NotAuthorizedErrorClient extends CustomErrorClient {
  NotAuthorizedErrorClient({required super.title, required super.description});
}


class NotAuthenticatedErrorClient extends CustomErrorClient {
  NotAuthenticatedErrorClient({required super.title, required super.description});
}

class InternalServerErrorClient extends CustomErrorClient {
  InternalServerErrorClient({required super.title, required super.description});
}


class UsernameHasAlreadyBeenTakenErrorClient extends CustomErrorClient {
  UsernameHasAlreadyBeenTakenErrorClient({required super.title, required super.description});
}

class EmailHasAlreadyBeenTakenErrorClient extends CustomErrorClient {
  EmailHasAlreadyBeenTakenErrorClient({required super.title, required super.description});
}