class Session {
  Future<void> commit() {
    throw UnimplementedError();
  }

  Future<void> rollback() {
    throw UnimplementedError();
  }

  Future<void> flush() {
    throw UnimplementedError();
  }

  Future<void> execute(String script, [List<String>? args]) {
    throw UnimplementedError();
  }
}


class AbstractUOW {
  Future<void> session(Future<void> Function(Session session) callback) {
    throw UnimplementedError();
  }

  Future<List<T>> atomicGet<T>(
      String query,
      T Function(Map<String, dynamic> row) serialize,
      [List<String>? args]
  ) {
    throw UnimplementedError();
  }

  void open() {
    throw UnimplementedError();
  }

  void close() {
    throw UnimplementedError();
  }

  void destroy() {
    throw UnimplementedError();
  }
}