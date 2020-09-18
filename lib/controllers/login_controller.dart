import 'package:bundle_yanga/services/interfaces/ilogin_service.dart';
import 'package:get/get.dart';

enum Status { loading, success, error }

class LoginController extends GetxController {
  final ILoginService loginService;
  final Function(String, String) loginComplete;
  final phone = RxString(null);
  final loginState = Rx<Future<AuthResponse>>();
  final verifyState = Rx<Future<AuthResponse>>();

  LoginController(this.loginService, this.loginComplete);

  Future<AuthResponse> login(String phoneNumber) async {
    phone(phoneNumber);
    return loginState(loginService.login(phoneNumber, '')).then((value) {
      if (value.error != null) {
        Get.snackbar("Error", value.error,
            colorText: Get.theme.accentColor,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.errorColor);
      }
      return value;
    });
  }

  verify(otp) async {
    Map map = {'phone': phone.value, 'otp': otp};
    verifyState(loginService.verify(map).then((res) {
      if (res.error != null) {
        return AuthResponse(false, error: res.error);
      }
      return AuthResponse(true, token: res.token);
    })).then((value) {
      if (value.error != null) {
        Get.snackbar("Error", value.error,
            colorText: Get.theme.accentColor,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.errorColor);
      } else {
        loginComplete(value.token, phone.value);
      }
    });
  }
}
