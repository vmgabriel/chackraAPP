import 'package:argos_home/domain/entity/task.dart' as entity_task;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Repository
import 'package:argos_home/domain/repository/commons.dart' as repository_commons;


class TaskRepository extends repository_commons.Repository<entity_task.Task> {
  TaskRepository({required super.uow});

  Future<entity_task.Task?> getByID(String id) {
    throw UnimplementedError();
  }

  Future<entity_paginator.Paginator<entity_task.Task>> get(entity_paginator.PaginatorRequest? paginatorRequest) {
    throw UnimplementedError();
  }
}