import 'dart:io';
import 'package:bundle_yanga/controllers/auth_controller.dart';
import 'package:bundle_yanga/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bundle_yanga/controllers/notifications.dart';
import 'package:bundle_yanga/bindings.dart';
import 'package:bundle_yanga/logger.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BGX] Event received');
  SharedPreferences prefs = await Get.putAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });
  Get.putAsync(() async => await Logger.init());
  String token = prefs.getString('token');
  bool notifyMe = prefs.getBool('notifyMe') ?? true;
  print("notify me: *********** $notifyMe");
  if (notifyMe && token != null) {
    AppBinding().dependencies();
    final NotificationsController notty = Get.find();
    print('trying');
    notty.onBackgroundFetch(taskId);
  } else {
    print('quiting');
  }
  BackgroundFetch.finish(taskId);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });
  final logger = await Get.putAsync(() async => await Logger.init());
  await Get.putAsync<AuthController>(() async {
    final authController = AuthController(authService: AuthService());
    await authController.initialize();
    return authController;
  });

  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
  logger.log('boot app');
  // logger.syncLogs();
  print('registering term task');
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color.fromRGBO(98, 167, 16, 1),
        primaryColorLight: Color.fromRGBO(219, 255, 177, 1),
        primaryColorDark: Color.fromRGBO(76, 175, 80, 0.3),
        accentColor: Colors.white,
        cardColor: Color(0xffffffff),
        backgroundColor: Color.fromRGBO(219, 255, 177, 1),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(98, 167, 16, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0))),
          textTheme: ButtonTextTheme.primary,
        ),
        disabledColor: Color(0xffdfdfdf),
        iconTheme: IconThemeData(color: Colors.white),
        primaryIconTheme: IconThemeData(color: Color.fromRGBO(98, 167, 16, 1)),
        scaffoldBackgroundColor: Color(0xfffff6f6),
        toggleableActiveColor: Color.fromRGBO(98, 167, 16, 1),
      ),
      initialRoute: Get.find<AuthController>().isLoggedIn()
          ? AppPages.INITIAL
          : AppPages.AUTH,
      getPages: AppPages.routes,
    );
  }
}
