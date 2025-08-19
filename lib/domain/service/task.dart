// Entity
import 'package:argos_home/domain/entity/task.dart' as entity_task;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Repositories
import 'package:argos_home/domain/repository/task_repository.dart' as repository_task;

// Exceptions
import 'package:argos_home/domain/port/server/exceptions.dart' as exception_port;

// Infra
import 'package:argos_home/infra/builder.dart' as infra_builder;


class TaskService {
  infra_builder.InfraBuilder infraBuilder = infra_builder.InfraBuilder.build();

  TaskService({infra_builder.InfraBuilder? infraBuilder});

  Future<entity_paginator.Paginator<entity_task.Task>> get(
      entity_paginator.PaginatorRequest? request,
      ) async {
    if (request == null || request.page == 1) {
      print("Executing sync");
      await infraBuilder.executeSync("task");
      print("Executed sync");
    }

    var taskRepository = infraBuilder.getRepository<repository_task.TaskRepository>("task");

    try {
      return await taskRepository.get(request);
    } on exception_port.NotValidErrorClient {
      print("NotValidErrorClient");
      return entity_paginator.Paginator<entity_task.Task>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } on exception_port.InternalServerErrorClient {
      print("InternalServerErrorClient");
      return entity_paginator.Paginator<entity_task.Task>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } on exception_port.NotAuthenticatedErrorClient {
      print("NotAuthenticatedErrorClient");
      return entity_paginator.Paginator<entity_task.Task>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } on exception_port.NotAuthorizedErrorClient {
      print("NotAuthorizedErrorClient");
      return entity_paginator.Paginator<entity_task.Task>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    } catch (e) {
      print("e - $e");
      return entity_paginator.Paginator<entity_task.Task>(
          elements: [],
          page: 1,
          total: 0,
          hasNext: false,
          request: entity_paginator.PaginatorRequest()
      );
    }
  }
}