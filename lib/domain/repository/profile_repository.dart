import 'package:argos_home/domain/entity/profile.dart' as profile_domain;

// Repository
import 'package:argos_home/domain/repository/commons.dart' as commons_repository;


class ProfileRepository extends commons_repository.Repository<profile_domain.Profile> {
  ProfileRepository({required super.uow});

  Future<profile_domain.Profile?> getByEmail(String email) {
    throw UnimplementedError();
  }
}