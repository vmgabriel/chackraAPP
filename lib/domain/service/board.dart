// Entity
import 'package:argos_home/domain/entity/board.dart' as board_entity;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Repositories
import 'package:argos_home/domain/repository/board_repository.dart' as board_repository;

// Exceptions
import 'package:argos_home/domain/port/server/exceptions.dart' as exception_port;

// Infra
import 'package:argos_home/infra/builder.dart' as infra_builder;


class BoardService {
  infra_builder.InfraBuilder infraBuilder = infra_builder.InfraBuilder.build();

  BoardService({infra_builder.InfraBuilder? infraBuilder});

  Future<entity_paginator.Paginator<board_entity.Board>> get(
      entity_paginator.PaginatorRequest? request,
  ) async {
    if (request == null || request.page == 1) {
      print("Executing sync");
      await infraBuilder.executeSync("board");
      print("Executed sync");
    }
    var boardRepository = infraBuilder.getRepository<board_repository.BoardRepository>("board");

    try {
      return await boardRepository.byILikeName(request);
    } on exception_port.NotValidErrorClient {
      return entity_paginator.Paginator<board_entity.Board>(
        elements: [],
        page: 1,
        total: 0,
        hasNext: false,
        request: entity_paginator.PaginatorRequest()
      );
    } on exception_port.InternalServerErrorClient {
      return entity_paginator.Paginator<board_entity.Board>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } on exception_port.NotAuthenticatedErrorClient {
      return entity_paginator.Paginator<board_entity.Board>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } on exception_port.NotAuthorizedErrorClient {
      return entity_paginator.Paginator<board_entity.Board>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } catch (e) {
      print("e - $e");
      return entity_paginator.Paginator<board_entity.Board>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    }
  }
}