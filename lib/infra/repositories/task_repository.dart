import 'dart:convert';

// Domain Entity
import 'package:argos_home/domain/entity/task.dart' as entity_task;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Domain Repository
import 'package:argos_home/domain/repository/task_repository.dart' as domain_repository_task;
import 'package:http/http.dart';

// Commons
import 'package:argos_home/domain/repository/commons.dart' as repository_commons;


class SqliteTaskRepository extends domain_repository_task.TaskRepository {
  SqliteTaskRepository({required super.uow});

  @override
  Future<entity_task.Task?> getByID(String id) async {
    const String selectByIdQuery = "SELECT * FROM tbl_task WHERE id = ?";

    List<entity_task.Task> context = await uow.atomicGet<entity_task.Task>(
      selectByIdQuery,
      entity_task.Task.fromRow,
      [id],
    );
    return context.isEmpty ? null : context.first;
  }

  @override
  Future<void> save(entity_task.Task record) async {
    const String insertQuery = "INSERT INTO tbl_task (id, name, description, priority, status, board_id, owner, icon_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    return await uow.session((session) async {
      await session.execute(insertQuery, [record.id, record.name, record.description, record.priority.name, record.status.name, record.boardId, json.encode(record.owner), record.iconUrl ?? ""]);;
      await session.commit();
    });
  }

  @override
  Future<void> update(String id, entity_task.Task record) async {
    const String updateQuery = "UPDATE tbl_task SET name = ?, description = ?, priority = ?, status = ?, board_id = ?, owner = ?, icon_url = ? WHERE id = ?";
    return uow.session((session) async {
      await session.execute(updateQuery, [
        record.name,
        record.description,
        record.priority.name,
        record.status.name,
        record.boardId,
        json.encode(record.owner),
        record.iconUrl ?? "", id]
      );
      await session.commit();
    });
  }

  @override
  Future<entity_paginator.Paginator<entity_task.Task>> get(
      entity_paginator.PaginatorRequest? paginatorRequest
  ) async {
    const limitPage = 100;
    var page = paginatorRequest?.page ?? 1;
    var boardId = paginatorRequest?.filters["board_id"] ?? "";

    const String selectCountByBoardIdQuery = "SELECT COUNT(*) FROM tbl_task WHERE board_id = ?";
    const String selectByBoardIdQuery = "SELECT * FROM tbl_task WHERE board_id = ? LIMIT $limitPage OFFSET ?";
    List<repository_commons.CountResponse> countContext = await uow.atomicGet<repository_commons.CountResponse>(
      selectCountByBoardIdQuery,
      (Map<String, dynamic> row) => repository_commons.CountResponse(count: row["COUNT(*)"] ?? 0),
      [boardId],
    );
    repository_commons.CountResponse total = countContext.first;
    List<entity_task.Task> context = await uow.atomicGet<entity_task.Task>(
      selectByBoardIdQuery,
      entity_task.Task.fromRow,
      [boardId, (page - 1).toString()],
    );

    return entity_paginator.Paginator(
      request: paginatorRequest ?? entity_paginator.PaginatorRequest(
        filters: {},
        orderBy: {},
        page: page,
      ),
      elements: context,
      total: total.count,
      hasNext: total.hasNext(page, limitPage),
      page: page,
    );
  }
}