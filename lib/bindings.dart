import 'package:bundle_yanga/controllers/auth_controller.dart';
import 'package:bundle_yanga/controllers/bundles.dart';
import 'package:bundle_yanga/controllers/login_controller.dart';
import 'package:bundle_yanga/controllers/notifications.dart';
import 'package:bundle_yanga/screens/home/home.dart';
import 'package:bundle_yanga/screens/login/login.dart';
import 'package:bundle_yanga/services/bundle_service.dart';
import 'package:bundle_yanga/services/notifications.dart';
import 'package:bundle_yanga/services/login_service.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.HOME;
  static const AUTH = Routes.AUTH;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: AppBinding()),
    GetPage(name: Routes.AUTH, page: () => LoginPage(), binding: AuthBinding()),
  ];
}

abstract class Routes {
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const DETAILS = '/details';
}

class AppBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    String token = Get.find<AuthController>().token.value;
    String phone = Get.find<AuthController>().phone.value;
    final notty = Get.put(NotificationsController(NotificationService()));
    notty.initialize();
    Get.lazyPut(
        () => BundlesController(BundleService(phone, token, Get.find())));
  }
}

class AuthBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get.put(LoginController(
        LoginService(Get.find()), Get.find<AuthController>().loginComplete));
  }
}
