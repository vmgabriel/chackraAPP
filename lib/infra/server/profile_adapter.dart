// Entities
import 'package:argos_home/domain/entity/profile.dart' as profile_entity;

// Ports
import 'package:argos_home/domain/port/server/profile.dart' as profile_port;
import 'package:argos_home/domain/port/server/request.dart' as request_port;
import 'package:argos_home/domain/port/server/exceptions.dart' as exception_port;

// Infra
import 'package:argos_home/infra/server/common.dart' as server_common;


class ProfileGetRequest extends request_port.RequestServer {

  ProfileGetRequest();

  @override
  Map<String, dynamic> toJson() {
    return {
      "trace_id": traceId,
    };
  }
}

class ProfileAdapterApiServer extends profile_port.ProfileApiHttp {
  ProfileAdapterApiServer();

  @override
  Future<profile_entity.Profile> get() async {
    var profileRequestObject = ProfileGetRequest();

    var response = await server_common.sendServerRequest(
        method: "GET",
        uri: "v1/users/myself",
        request: profileRequestObject,
        withAuthorization: true
    );
    return response.deserialize<profile_entity.Profile>(
        fromJson: profile_entity.Profile.fromJson
    );
  }
}

class UserSaveRequest extends request_port.RequestServer {
  final profile_entity.User user;

  UserSaveRequest(this.user);

  @override
  Map<String, dynamic> toJson() {
    return {
      "trace_id": traceId,
      "name": user.name,
      "last_name": user.lastName,
      "username": user.username,
      "email": user.email,
      "phone": user.phone,
      "password": user.password,
      "repeat_password": user.repeatPassword,
    };
  }
}


class UserAdapterApiServer extends profile_port.UserApiHttp {
  UserAdapterApiServer();

  @override
  Future<void> create(profile_entity.User newUser) async {
    var userRequestObject = UserSaveRequest(newUser);

    var response = await server_common.sendServerRequest(
        method: "POST",
        uri: "v1/users",
        request: userRequestObject
    );
    if (response.errors.isNotEmpty) {
      var first_error = response.errors.first;
      String type = first_error["type"];
      String message = first_error["message"];
      if (type == "ValueError") {
        if (message == "Username already exists") {
          throw exception_port.UsernameHasAlreadyBeenTakenErrorClient(title: type, description: message);
        }
        if (message == "Email already exists") {
          throw exception_port.EmailHasAlreadyBeenTakenErrorClient(title: type, description: message);
        }
      }
    }
  }
}