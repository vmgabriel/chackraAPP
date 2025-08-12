import 'package:argos_home/tools/auth_service.dart' as auth_service;
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton(auth_service.AuthService());
}
