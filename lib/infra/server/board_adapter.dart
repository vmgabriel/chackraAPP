// Entities
import 'package:argos_home/domain/entity/board.dart' as entity_board;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Port
import 'package:argos_home/domain/port/server/request.dart' as domain_server_request;
import 'package:argos_home/domain/port/server/board.dart' as port_server_board;

// Infra
import 'package:argos_home/infra/server/common.dart' as server_common;


class boardsGetRequestObject  extends domain_server_request.RequestServer {
  int page = 1;
  List<String>? orderBy;

  boardsGetRequestObject({this.orderBy, this.page = 1});

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


class BoardAdapterApiService extends port_server_board.BoardApiHttp {
  BoardAdapterApiService();
  @override
  Future<entity_paginator.Paginator<entity_board.Board>?> get(entity_paginator.PaginatorRequest? request) async {
    var boardRequest = boardsGetRequestObject();
    if (request != null) {
      boardRequest.page = request.page;
    }

    var response = await server_common.sendServerRequest(
        method: "GET",
        uri: "v1/boards",
        request: boardRequest,
        withAuthorization: true
    );

    List<dynamic> data = response.payload["elements"] ?? [];
    if (data.isEmpty) {
      return null;
    }
    List<entity_board.Board> boards = data.map((item) => entity_board.Board.fromJson(item)).toList();
    return entity_paginator.Paginator<entity_board.Board>(
      request: entity_paginator.PaginatorRequest(
        page: boardRequest.page + 1,
        orderBy: {},
        filters: {},
      ),
      elements: boards,
      total: response.payload["total"] ?? 0,
      page: boardRequest.page,
      hasNext: response.payload["has_next"] ?? false,
    );
  }
}