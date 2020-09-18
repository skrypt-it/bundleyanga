import 'package:bundle_yanga/controllers/notifications.dart';
import 'package:bundle_yanga/models/balance.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/models/bundles.dart';
import 'package:bundle_yanga/services/bundle_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BundlesController extends GetxController {
  final bundles = Rx<Future<Bundles>>();
  final phone = RxString('');
  final token = RxString('');
  final notifyMe = RxBool(true);
  final loadingBalance = RxBool(true);
  final refreshing = RxBool(false);
  final scheduled = RxBool(false);
  final refresher = RxBool(false);
  final balance = Rx<Future<Balance>>();
  final BundleService bundleService;
  Future<List<ActiveBundle>> get reallyActiveBundles =>
      balance.value.then((value) => value.bundles
          .where((bundle) => bundle.expiry.isAfter(DateTime.now()))
          .toList());
  BundlesController(this.bundleService);

  @override
  void onInit() {
    checkYanga();
    checkBalance();
    super.onInit();
  }

  Future<Bundles> checkYanga({bool active = true}) async {
    return bundles(this.bundleService.checkYanga());
  }

  Future<Balance> checkBalance({bool active = true}) async {
    return balance(this.bundleService.checkBalance()).then((value) {
      if (value.bundles.length > 0) scheduleBalanceCheck();
      return value;
    }).catchError((e) {
      scheduleBalanceCheck();
      return Future.error(e);
    });
  }

  buyBundle(Bundle bundle) async {
    return this.bundleService.buyBundle(bundle).then((value) {
      Get.snackbar("Bundle Purchase", "Your bundle has been purchased",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Get.theme.accentColor,
          backgroundColor: Get.theme.primaryColor);
      bool expiryReminder =
          Get.find<SharedPreferences>().getBool('expiryReminder') ?? true;
      if (expiryReminder) {
        Get.find<NotificationsController>().scheduleNotification('Bundle Yange',
            'Your bundle is about to expire', value.bundles.last.validity);
      }
      scheduleBalanceCheck();
      return balance(Future.value(value));
    }).catchError((e) async {
      Get.snackbar("Error", e.toString(),
          colorText: Colors.white, backgroundColor: Get.theme.errorColor);
    });
  }

  scheduleBalanceCheck() async {
    if (!scheduled.value) {
      scheduled(true);
      await Future.delayed(Duration(minutes: 1));
      checkBalance();
      scheduled(false);
    }
  }

  Future<bool> scheduleRefresh({Duration duration}) async {
    if (!refresher.value) {
      refresher(true);
      if (duration != null) {
        await Future.delayed(duration);
      }
      balance(balance.value.then((value) => value));
      refresher(false);
      return true;
    }
    return false;
  }
}
