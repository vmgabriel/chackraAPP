import 'dart:core';

import 'package:uuid/v4.dart';

class RequestServer{
  String traceId = UuidV4().generate();

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class ResponseServer{
  Map<String, dynamic> payload;
  List<Map<String, dynamic>> errors;
  String traceId;

  ResponseServer({required this.payload, required this.errors, required this.traceId});

  factory ResponseServer.fromJson(Map<String, dynamic> json) {

    final List<Map<String, dynamic>> errors = (json["errors"] as List<dynamic>)
        .map((item) => item as Map<String, dynamic>)
        .toList()
    ;

    return ResponseServer(
        payload: json["payload"],
        errors: errors,
        traceId: json["trace_id"]
    );
  }

  Map<String, dynamic>? lastError() {
    if (errors.isEmpty) {
      return null;
    }
    return errors.last;
  }

  String? titleLastError() {
    Map<String, dynamic>? error = lastError();
    if (error == null) {
      return null;
    }
    return error["title"];
  }

  String? descriptionLastError() {
    Map<String, dynamic>? error = lastError();
    if (error == null) {
      return null;
    }
    return error["description"];
  }

  T deserialize<T>({required T Function(Map<String, dynamic>) fromJson}) {
    if (payload.isEmpty) {
      throw ArgumentError('Payload is empty');
    }
    return fromJson(payload);
  }
}