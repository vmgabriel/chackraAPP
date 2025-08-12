// Domain Entity
import 'package:argos_home/domain/entity/profile.dart' as profile_domain;

// Domain Repository
import 'package:argos_home/domain/repository/profile_repository.dart' as domain_profile_repository;


class SqliteProfileRepository extends domain_profile_repository.ProfileRepository {
  SqliteProfileRepository({required super.uow});

  @override
  Future<profile_domain.Profile?> getByEmail(String email) async {
    const String selectByEmailQuery = "SELECT * FROM tbl_profile WHERE email = ?";

    List<profile_domain.Profile> context = await uow.atomicGet<profile_domain.Profile>(
      selectByEmailQuery,
      profile_domain.Profile.fromRow,
      [email],
    );
    return context.isNotEmpty ? context.first : null;
  }

  @override
  Future<void> save(profile_domain.Profile record) async {
    const String insertQuery = "INSERT INTO tbl_profile (id, image_url, name, last_name, username, description, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
    await uow.session((session) async {
      await session.execute(
        insertQuery,
        [
          record.id,
          record.imageUrl,
          record.name,
          record.lastName,
          record.username,
          record.description,
          record.email,
        ]
      );
      await session.commit();
    });
  }

  @override
  Future<void> update(String id, profile_domain.Profile record) async {
    const String updateQuery = "UPDATE tbl_profile SET image_url = ?, name = ?, last_name = ?, username = ?, description = ?, email = ? WHERE id = ?";

    await uow.session((session) async {
      await session.execute(
          updateQuery,
          [
            record.imageUrl,
            record.name,
            record.lastName,
            record.username,
            record.description,
            record.email,
            id
          ]
      );
      await session.commit();
    });
  }
}