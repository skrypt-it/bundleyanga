import 'package:bundle_yanga/services/interfaces/iauth_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService implements IAuthService {
  Future<void> persistLogin(token, phone) async {
    SharedPreferences prefs = Get.find();
    await prefs.setString('phone', phone);
    await prefs.setString('token', token);
  }

  Future<void> logout() async {
    SharedPreferences prefs = Get.find();
    prefs.remove('token');
    prefs.remove('phone');
    await prefs.setBool('notifyMe', false);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = Get.find();
    return prefs.getString('token') != null;
  }

  @override
  Future<String> getToken() async {
    SharedPreferences prefs = Get.find();
    return prefs.getString('token');
  }

  @override
  Future<String> getPhone() async {
    SharedPreferences prefs = Get.find();
    return prefs.getString('phone');
  }
}
