import 'dart:math';
import 'package:background_fetch/background_fetch.dart';
import 'package:bundle_yanga/controllers/bundles.dart';
import 'package:bundle_yanga/logger.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/models/bundles.dart';
import 'package:bundle_yanga/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsController extends GetxController {
  final status = RxBool(true);
  final NotificationService notificationService;

  NotificationsController(this.notificationService);

  void initialize() {
    print('init notifications');
    if (!this.initialized) {
      print('initing bg');
      checkStatus();
      if (status.value) {
        notificationService.initBackgroundNotifications(onBackgroundFetch);
      }
    }
  }

  toggle() {
    Logger logger = Get.find();
    if (!status.value) {
      notificationService
          .toggleNotifications(true)
          .then((value) => Get.snackbar(
              "Notifications", "Notifications have been enabled",
              colorText: Colors.white))
          .catchError((e) {
        Get.snackbar(
            "Notifications", 'Notifications enabling failed. Try again.',
            colorText: Colors.white);
        logger.error('Background Task toggle failed', {"error": e.toString()});
      });
    } else {
      notificationService.toggleNotifications(true).then((value) =>
          Get.snackbar("Notifications", "Notifications have been disabled",
              colorText: Colors.white));
    }
    status(!status.value);
    logger.event('Background Task Toggle', {"bgTask": status.value.toString()});
  }

  checkStatus() {
    status(notificationService.checkStatus());
  }

  void onBackgroundFetch(taskId) async {
    print('[BG] Event received');
    SharedPreferences prefs = Get.find();
    int minPercent = prefs.getInt('minPercent') ?? 50;
    await Get.find<BundlesController>().checkYanga(active: false).then((info) {
      Get.find<Logger>().event(
          'Background Task:Active', {"percentage": info.percent.toString()});
      print("${info.percent} found from $minPercent");
      if (info.percent >= minPercent) {
        notify();
      }
      BackgroundFetch.finish(taskId);
    }).catchError((e) => BackgroundFetch.finish(taskId));
  }

  void notify() async {
    await notificationService.cancelAllNotifications();
    Random rnd = new Random();
    Bundles bundles = await Get.find<BundlesController>().bundles.value;
    Bundle bundle = bundles.list[rnd.nextInt(bundles.list.where((bundle) {
      return bundle.percent == bundles.percent;
    }).length)];
    print("notifying");
    notificationService.showNotification(
        "${bundle.percent}% Discount",
        "Buy a dynamic bundles now at ${bundle.percent}%: ${bundle.price}",
        bundles.list.map((b) => b.toMap()).toList());
  }

  scheduleNotification(String title, String body, int minutes) {
    var time = DateTime.now().add(Duration(minutes: minutes));
    notificationService.scheduleReminder(title, body, time);
  }
}
