import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// Ports
import 'package:argos_home/domain/port/server/exceptions.dart' as exception_port;
import 'package:argos_home/domain/port/server/request.dart' as request_port;

// Server Configurations
import 'package:argos_home/infra/server/configuration.dart' as configuration_server;


final RegExp separatedByPascalCaseRegex = RegExp(r'([A-Z]?[a-z0-9]*)');

Map<String, dynamic> formatedJson(Map<String, dynamic> data) {
  Map<String, dynamic> dataFormated = {};
  for (var key in data.keys) {
    var keyMatches = separatedByPascalCaseRegex.allMatches(key.toString());
    String keyInCamel = keyMatches.join("_").toLowerCase();
    dataFormated[keyInCamel.toString()] = data[key];
  }

  return dataFormated;
}


class HttpResponse {
  final int statusCode;
  final String body;
  final List<int> bodyBytes;
  final Map<String, String> headers;
  final bool isJson;

  HttpResponse({
    required this.statusCode,
    required this.body,
    required this.bodyBytes,
    required this.headers,
    required this.isJson,
  });

  Map<String, dynamic>? tryJsonDecode() {
    if (!isJson) return null;
    try {
      return json.decode(body) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => 'HttpResponse($statusCode, body: ${body.length} chars)';
}


Future<HttpResponse> sendRequest({
  required String method,
  required String url,
  String contentType = 'application/json',
  String accept = 'application/json',
  dynamic body,
  Map<String, String> additionalHeaders = const {},
  Duration timeout = const Duration(seconds: 15),
}) async {
  final uri = Uri.parse(url);

  final headers = {
    'Content-Type': contentType,
    'Accept': accept,
    ...additionalHeaders,
  };

  String? bodyString;
  if (body != null) {
    if (body is String) {
      bodyString = body;
    } else if (body is Map || body is List) {
      bodyString = json.encode(body);
    } else {
      bodyString = body.toString();
    }
  }

  final client = http.Client();

  try {
    final request = http.Request(method, uri)
      ..headers.addAll(headers)
      ..body = bodyString ?? '';

    final httpResponse = await client.send(request).timeout(timeout);

    final response = await http.Response.fromStream(httpResponse);

    final isJson = response.headers['content-type']
        ?.toLowerCase()
        .contains('application/json') ??
        false;

    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
      bodyBytes: response.bodyBytes,
      headers: response.headers,
      isJson: isJson,
    );
  } on TimeoutException {
    throw TimeoutException('Timeout', timeout);
  } on http.ClientException catch (e) {
    throw Exception('HTTP Client error: ${e.message}');
  } on Exception {
    rethrow;
  } finally {
    client.close();
  }
}


Future<request_port.ResponseServer> sendServerRequest({
  required String method,
  required String uri,
  required request_port.RequestServer request,
  bool withAuthorization = false,
}) async {
  var url = Uri(
      scheme: "http",
      host: configuration_server.URL_SERVER,
      path: uri,
      port: 3030
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (method.toUpperCase() == "GET") {
    url = url.replace(queryParameters: request.toJson());
  }

  Map<String, String> additionalAuthorization = {};
  if (withAuthorization) {
    additionalAuthorization = {
      "Authorization": "${prefs.getString('typeToken')!} ${prefs.getString('token')!}"
    };
  }

  HttpResponse response = await sendRequest(
    method: method,
    url: url.toString(),
    body: ((method.toUpperCase() != "GET") ? request.toJson() : null),
    additionalHeaders: additionalAuthorization
  );
  print("response ${response.body}");

  if (response.statusCode >= 500) {
    throw exception_port.InternalServerErrorClient(
        title: "Internal Server",
        description: "Internal Server Error"
    );
  }
  if (response.statusCode == 400) {
    throw exception_port.NotValidErrorClient(
        title: "Not Valid Error",
        description: "Not valid Exception"
    );
  }
  if (response.statusCode == 401) {
    throw exception_port.NotAuthorizedErrorClient(
        title: "Not Authorized Error",
        description: "Not Authorized Exception"
    );
  }
  if (response.statusCode == 403) {
    throw exception_port.NotAuthenticatedErrorClient(
        title: "Not Authenticated Error",
        description: "Not Authenticated Exception"
    );
  }
  if (response.statusCode > 400) {
    throw exception_port.NotValidErrorClient(
        title: "Not Valid Error",
        description: "Not valid Exception"
    );
  }
  return request_port.ResponseServer.fromJson(response.tryJsonDecode()!);
}
