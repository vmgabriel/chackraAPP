import 'package:flutter_riverpod/flutter_riverpod.dart';

// Entity
import 'package:argos_home/domain/entity/board.dart' as entity_board;
import 'package:argos_home/domain/entity/paginator.dart' as entity_paginator;

// Services
import 'package:argos_home/domain/service/board.dart' as services_board;

// Infra
import 'package:argos_home/infra/builder.dart' as infra_builder;



final boardListProvider = FutureProvider.family<
    entity_paginator.Paginator<entity_board.Board>,
    entity_paginator.PaginatorRequest?
> ((ref, paginatorRequest) async {
  print('🔍 Llamando boardListProvider con: $paginatorRequest'); // 👈
  final builder = infra_builder.InfraBuilder.build();
  final service = services_board.BoardService(infraBuilder: builder);
  try {
    var data = await service.get(paginatorRequest);
    print('✅ Éxito: ${data.elements.length} boards'); // 👈
    return data;
  } catch (e) {
    print('❌ Error: $e'); // 👈
    rethrow;
  }
});