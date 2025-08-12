import 'package:argos_home/domain/entity/board.dart' as entity_board;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Repository
import 'package:argos_home/domain/repository/commons.dart' as repository_commons;


class BoardRepository extends repository_commons.Repository<entity_board.Board> {
  BoardRepository({required super.uow});

  Future<entity_board.Board?> getByID(String id) {
    throw UnimplementedError();
  }

  Future<entity_paginator.Paginator<entity_board.Board>> byILikeName(
      entity_paginator.PaginatorRequest? paginatorRequest,
  ) {
    throw UnimplementedError();
  }
}