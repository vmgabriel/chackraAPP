// Domain Entity
import 'package:argos_home/domain/entity/access.dart' as access_domain;

// Domain Repository
import 'package:argos_home/domain/repository/access_repository.dart' as domain_access_repository;


class SqliteAccessRepository extends domain_access_repository.AccessRepository {
  SqliteAccessRepository({required super.uow});

  @override
  Future<access_domain.AccessToken?> getByEmail(String email) async {
    const String selectByEmailQuery = "SELECT * FROM tbl_access WHERE email = ?";

    List<access_domain.AccessToken> context = await uow.atomicGet<access_domain.AccessToken>(
      selectByEmailQuery,
      access_domain.AccessToken.fromRow,
      [email],
    );
    return context.isNotEmpty ? context.first : null;
  }

  @override
  Future<void> saveAs(String email, access_domain.AccessToken record) async {
    const String insertQuery = "INSERT INTO tbl_access (email, access_token, refresh_token, type, expires_at) VALUES (?, ?, ?, ?, ?)";
    await uow.session((session) async {
      await session.execute(
        insertQuery,
        [
          email,
          record.accessToken,
          record.refreshToken,
          record.type,
          record.expirationToken.toIso8601String(),
        ]
      );
      await session.commit();
    });
  }

  @override
  Future<void> update(String id, access_domain.AccessToken record) async {
    const String updateQuery = "UPDATE tbl_access SET access_token = ?, refresh_token = ?, type = ?, expires_at = ? WHERE email = ?";
    await uow.session((session) async {
      await session.execute(
        updateQuery,
        [
          record.accessToken,
          record.refreshToken,
          record.type,
          record.expirationToken.toIso8601String(),
          id,
        ]
      );
      await session.commit();
    });
  }
}