// Entities
import 'package:argos_home/domain/entity/board.dart' as entity_board;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

import 'package:argos_home/domain/port/server/commons.dart' as commons_port;



class BoardApiHttp extends commons_port.AbstractServerHttp {
  BoardApiHttp();

  Future<entity_paginator.Paginator<entity_board.Board>?> get(entity_paginator.PaginatorRequest? request) {
    throw UnimplementedError();
  }
}