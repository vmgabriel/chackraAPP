import 'package:flutter_riverpod/flutter_riverpod.dart';

// Entity
import 'package:argos_home/domain/entity/task.dart' as entity_task;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Services
import 'package:argos_home/domain/service/task.dart' as services_task;

// Infra
import 'package:argos_home/infra/builder.dart' as infra_builder;



final taskListProvider = FutureProvider.family<
    entity_paginator.Paginator<entity_task.Task>,
    entity_paginator.PaginatorRequest?
> ((ref, paginatorRequest) async {
  final builder = infra_builder.InfraBuilder.build();
  final service = services_task.TaskService(infraBuilder: builder);
  try {
    var data = await service.get(paginatorRequest);
    return data;
  } catch (e) {
    rethrow;
  }
});