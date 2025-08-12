import 'package:flutter/foundation.dart' show mapEquals;

class PaginatorRequest {
  final Map<String, String> filters;
  final Map<String, String> orderBy;
  final int page;

  const PaginatorRequest({
    Map<String, String>? filters,
    Map<String, String>? orderBy,
    this.page = 1,
  })  : filters = filters ?? const {},
        orderBy = orderBy ?? const {};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaginatorRequest &&
              runtimeType == other.runtimeType &&
              page == other.page &&
              mapEquals(filters, other.filters) &&
              mapEquals(orderBy, other.orderBy);

  @override
  int get hashCode => Object.hash(page, filters, orderBy);
}


class Paginator<T> {
  PaginatorRequest request;
  int total;
  int page;
  bool hasNext;
  List<T> elements;

  Paginator({required this.elements, required this.total, required this.hasNext, required this.page, required this.request});

  PaginatorRequest getRequestForNextPaginator() {
    return PaginatorRequest(filters: request.filters, orderBy: request.orderBy, page: request.page + 1);
  }

}