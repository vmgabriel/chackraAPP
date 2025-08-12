// Ports
import 'package:argos_home/domain/port/uow/commons.dart' as commons_port;


class Repository<T> {
  commons_port.AbstractUOW uow;

  Repository({required this.uow});

  Future<void> save(T record) {
    throw UnimplementedError();
  }

  Future<void> update(String id, T record) {
    throw UnimplementedError();
  }
}