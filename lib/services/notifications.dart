import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:bundle_yanga/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  init() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  bool checkStatus() {
    SharedPreferences prefs = Get.find();
    bool nt = prefs.getBool('notifyMe');
    if (nt == null) {
      prefs.setBool('notifyMe', false);
      nt = true;
    }
    return nt;
  }

  int getInterval() {
    SharedPreferences prefs = Get.find();
    return prefs.getInt('interval') ?? 15;
  }

  initBackgroundNotifications(Function fetch) {
    print(
        "Next bg task at ${DateTime.now().add(Duration(minutes: getInterval())).toIso8601String()}");
    BackgroundFetch.configure(
            BackgroundFetchConfig(
                minimumFetchInterval: getInterval(),
                stopOnTerminate: false,
                startOnBoot: true,
                enableHeadless: true,
                requiredNetworkType: NetworkType.ANY),
            fetch)
        .catchError((e) {
      print('[BG] configure ERROR: $e');
      Get.find<Logger>()
          .error('Background Task setup failed', {"error": e.toString()});
    });
  }

  Future<void> onSelectNotification(String payload) async {}

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleReminder(
      String title, String body, DateTime time) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Yanga', 'Bundles', 'Bundle Expiration Reminder',
        playSound: true,
        importance: Importance.Max,
        priority: Priority.Max,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, title, body, time, platformChannelSpecifics);
  }

  Future<void> showNotification(
      String title, String body, dynamic payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Yanga', 'Bundles', 'Bundle discount info',
        playSound: true,
        importance: Importance.Max,
        priority: Priority.Max,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: jsonEncode(payload));
  }

  Future<int> toggleNotifications(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifyMe', status);
    if (status) return BackgroundFetch.start();
    return BackgroundFetch.stop();
  }
}
