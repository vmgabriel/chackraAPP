// Entities
import 'package:argos_home/domain/entity/task.dart' as entity_task;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

import 'package:argos_home/domain/port/server/commons.dart' as commons_port;


class TaskApiHttp extends commons_port.AbstractServerHttp {
  TaskApiHttp();

  Future<entity_paginator.Paginator<entity_task.Task>?> get(entity_paginator.PaginatorRequest? request) {
    throw UnimplementedError();
  }
}