import 'package:argos_home/domain/entity/access.dart' as access_entity;

import 'package:argos_home/domain/port/server/commons.dart' as commons_port;


class LoginApiHttp extends commons_port.AbstractServerHttp {
  LoginApiHttp();

  Future<access_entity.AccessToken> login(String email, String password) {
    throw UnimplementedError();
  }

  Future<access_entity.AccessToken> refresh(String refreshToken) {
    throw UnimplementedError();
  }
}