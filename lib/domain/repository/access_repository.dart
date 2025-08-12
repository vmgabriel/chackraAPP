import 'package:argos_home/domain/entity/access.dart' as access_domain;

// Repository
import 'package:argos_home/domain/repository/commons.dart' as commons_repository;


class AccessRepository extends commons_repository.Repository<access_domain.AccessToken> {
  AccessRepository({required super.uow});

  Future<access_domain.AccessToken?> getByEmail(String email) {
    throw UnimplementedError();
  }

  Future<void> saveAs(String email, access_domain.AccessToken record) async {
    throw UnimplementedError();
  }
}