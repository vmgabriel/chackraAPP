// Entities
import 'package:argos_home/domain/entity/access.dart' as access_entity;

// Ports
import 'package:argos_home/domain/port/server/login.dart' as login_port;
import 'package:argos_home/domain/port/server/request.dart' as request_port;
import 'package:argos_home/domain/port/server/exceptions.dart' as exception_port;

// Infra
import 'package:argos_home/infra/server/common.dart' as server_common;


class LoginRequest extends request_port.RequestServer {
  String email;
  String password;

  LoginRequest({required this.email, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "trace_id": traceId
    };
  }
}

class RefreshRequest extends request_port.RequestServer {
  String refreshToken;

  RefreshRequest({required this.refreshToken});

  @override
  Map<String, dynamic> toJson() {
    return {
      "trace_id": traceId,
      "refresh_token": refreshToken
    };
  }
}


class LoginAdapterApiServer extends login_port.LoginApiHttp {
  LoginAdapterApiServer();

  @override
  Future<access_entity.AccessToken> login(String email, String password) async {
    var loginRequestObject = LoginRequest(email: email, password: password);

    var response = await server_common.sendServerRequest(
      method: "POST",
      uri: "v1/auth",
      request: loginRequestObject
    );

    if (response.payload["status"] == false) {
      throw exception_port.NotAuthenticatedErrorClient(
          title: "Not Authenticated Error",
          description: "Not Authenticated Exception"
      );
    }

    return response.deserialize<access_entity.AccessToken>(
        fromJson: access_entity.AccessToken.fromJson
    );
  }

  @override
  Future<access_entity.AccessToken> refresh(String refreshToken) async {
    var loginRequestObject = RefreshRequest(refreshToken: refreshToken);

    var response = await server_common.sendServerRequest(
        method: "POST",
        uri: "v1/auth/refresh",
        request: loginRequestObject
    );
    return response.deserialize<access_entity.AccessToken>(
        fromJson: access_entity.AccessToken.fromJson
    );
  }
}