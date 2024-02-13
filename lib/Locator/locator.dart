import 'package:chatapp/Service/AuthService/auth_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerSingleton<AuthService>(AuthService());
}
