import 'package:bundle_yanga/bindings.dart';
import 'package:bundle_yanga/services/interfaces/iauth_service.dart';
import 'package:get/get.dart';

enum Status { loading, success, error }

class AuthController extends GetxController {
  AuthController({this.authService});

  final IAuthService authService;
  final status = Status.loading.obs;
  final token = ''.obs;
  final phone = ''.obs;
  final isLoggedIn = false.obs;

  Future<void> initialize() async {
    isLoggedIn(await authService.isLoggedIn());
    if (isLoggedIn.value) {
      phone(await authService.getPhone());
      token(await authService.getToken());
    }
  }

  Future<void> logout() async {
    await authService.logout();
    isLoggedIn(false);
    Get.offAndToNamed(Routes.AUTH);
  }

  Future<void> loginComplete(loginToken, phoneNumber) async {
    await authService.persistLogin(loginToken, phoneNumber);
    isLoggedIn(true);
    phone(phoneNumber);
    token(loginToken);
    Get.offAndToNamed(Routes.HOME);
  }
}
