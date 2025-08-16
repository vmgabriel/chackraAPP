// Entities
import 'package:argos_home/domain/entity/task.dart' as entity_task;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Port
import 'package:argos_home/domain/port/server/request.dart' as domain_server_request;
import 'package:argos_home/domain/port/server/task.dart' as port_server_task;

// Infra
import 'package:argos_home/infra/server/common.dart' as server_common;


class TasksGetRequestObject  extends domain_server_request.RequestServer {
  int page = 1;
  List<String>? orderBy;

  TasksGetRequestObject({this.orderBy, this.page = 1});

  @override
  Map<String, dynamic> toJson() {
    var orderByData = orderBy ?? [];
    var data = {
      "offset": page.toString(),
      "trace_id": traceId,
    };
    if (orderBy != null) {
      data["order_by"] = orderByData.join(",");
    }
    return data;
  }
}


class TaskAdapterApiService extends port_server_task.TaskApiHttp {
  TaskAdapterApiService();

  @override
  Future<entity_paginator.Paginator<entity_task.Task>?> get(entity_paginator.PaginatorRequest? request) async {
    var taskRequest = TasksGetRequestObject();
    if (request != null) {
      taskRequest.page = request.page;
    }

    String? boardId = "";
    if (request != null && request.filters.containsKey("board_id")) {
      boardId = request.filters["board_id"];
    }
    if (boardId!.isEmpty) {
      return null;
    }

    var response = await server_common.sendServerRequest(
        method: "GET",
        uri: "v1/boards/$boardId/tasks",
        request: taskRequest,
        withAuthorization: true
    );

    List<dynamic> data = response.payload["elements"] ?? [];
    if (data.isEmpty) {
      return null;
    }
    List<entity_task.Task> tasks = data.map((item) => entity_task.Task.fromJson(item)).toList();
    return entity_paginator.Paginator<entity_task.Task>(
      request: entity_paginator.PaginatorRequest(
        page: taskRequest.page + 1,
        orderBy: {},
        filters: {},
      ),
      elements: tasks,
      total: response.payload["total"] ?? 0,
      page: taskRequest.page,
      hasNext: response.payload["has_next"] ?? false,
    );
  }
}