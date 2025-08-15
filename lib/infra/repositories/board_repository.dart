// Domain Entity
import 'package:argos_home/domain/entity/board.dart' as entity_board;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Domain Repository
import 'package:argos_home/domain/repository/board_repository.dart' as board_repository_domain;


class SqliteBoardRepository extends board_repository_domain.BoardRepository {
  SqliteBoardRepository({required super.uow});

  @override
  Future<entity_board.Board?> getByID(String id) async {
    const String selectByIdQuery = "SELECT * FROM tbl_board WHERE id = ?";

    List<entity_board.Board> context = await uow.atomicGet<entity_board.Board>(
      selectByIdQuery,
      entity_board.Board.fromRow,
      [id],
    );
    return context.isEmpty ? null : context.first;
  }

  @override
  Future<entity_paginator.Paginator<entity_board.Board>> byILikeName(
      entity_paginator.PaginatorRequest? paginatorRequest,
  ) async {
    var page = paginatorRequest?.page ?? 1;
    var name = paginatorRequest?.filters["name"] ?? "";
    name = "%$name%";
    const String selectByNameQuery = "SELECT * FROM tbl_board WHERE name LIKE ? LIMIT 20 OFFSET ?";
    List<entity_board.Board> context = await uow.atomicGet<entity_board.Board>(
      selectByNameQuery,
      entity_board.Board.fromRow,
      [name, (page - 1).toString()],
    );
    return entity_paginator.Paginator(
        request: paginatorRequest ?? entity_paginator.PaginatorRequest(
          filters: {},
          orderBy: {},
          page: page,
        ),
        elements: context,
        total: context.length,
        hasNext: false,
        page: page,
    );
  }

  @override
  Future<void> save(entity_board.Board record) async {
    const String insertQuery = "INSERT INTO tbl_board (id, name, description, icon_url, background_color) VALUES (?, ?, ?, ?, ?)";
    return await uow.session((session) async {
      await session.execute(insertQuery, [record.id, record.name, record.description, record.imageUrl ?? "", record.backgroundColor ?? ""]);;
      await session.commit();
    });
  }

  @override
  Future<void> update(String id, entity_board.Board record) async {
    const String updateQuery = "UPDATE tbl_board SET name = ?, description = ?, icon_url = ?, background_color = ? WHERE id = ?";
    return uow.session((session) async {
      await session.execute(updateQuery, [record.name, record.description, record.imageUrl ?? "", record.backgroundColor ?? "", id]);
      await session.commit();
    });
  }
}
