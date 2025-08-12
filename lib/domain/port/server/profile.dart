import 'package:argos_home/domain/entity/profile.dart' as profile_entity;

import 'package:argos_home/domain/port/server/commons.dart' as commons_port;


class ProfileApiHttp extends commons_port.AbstractServerHttp {
  ProfileApiHttp();

  Future<profile_entity.Profile> get() {
    throw UnimplementedError();
  }
}

class UserApiHttp extends commons_port.AbstractServerHttp {
  UserApiHttp();

  Future<void> create(profile_entity.User newUser) {
    throw UnimplementedError();
  }
}