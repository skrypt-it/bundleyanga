import 'package:bundle_yanga/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:bundle_yanga/controllers/bundles.dart';
import 'package:bundle_yanga/models/balance.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/widgets/fcb.dart';
import 'package:bundle_yanga/screens/home/widgets/timerrefresh.dart';

class BundleBalance extends StatelessWidget {
  final BundlesController state = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: InkWell(
          onTap: () {
            state.checkBalance();
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              height: 45,
              child: Obx(() => FutureBuilder(
                    future: state.balance.value,
                    builder: (context, _) => _.connectionState ==
                            ConnectionState.waiting
                        ? Loader(
                            centralDotRadius: 14,
                          )
                        : FutureContent<Balance>(
                            future: state.balance.value,
                            builder: (context, value) {
                              var active = value.bundles
                                  .where((bundle) =>
                                      bundle.expiry.isAfter(DateTime.now()))
                                  .toList();
                              ActiveBundle bundleBalance = active.length > 0
                                  ? active.reduce((value, element) {
                                      return ActiveBundle(
                                          remaining: value.remaining +
                                              element.remaining,
                                          expiry: value.expiry
                                                  .isBefore(element.expiry)
                                              ? value.expiry
                                              : element.expiry);
                                    })
                                  : null;
                              Duration duration = bundleBalance != null
                                  ? bundleBalance.expiry.compareTo(
                                              DateTime.now()
                                                  .add(Duration(seconds: 60))) <
                                          0
                                      ? Duration(seconds: 1)
                                      : Duration(minutes: 1)
                                  : Duration(minutes: 1);
                              scheduling(bundleBalance);
                              return BundlePopup(value, bundleBalance, active,
                                  refreshRate: duration);
                            }),
                  ))),
        ));
  }

  void scheduling(ActiveBundle bundleBalance) async {
    if (bundleBalance != null &&
        bundleBalance.expiry
                .compareTo(DateTime.now().add(Duration(seconds: 60))) >
            0) {
      final bc = Get.find<BundlesController>();
      await bc.scheduleRefresh(
          duration: bundleBalance.expiry
              .difference(DateTime.now().add(Duration(minutes: 1))));
      await bc.scheduleRefresh(duration: Duration(minutes: 1));
    }
  }
}

class BundlePopup extends TimerRefreshWidget {
  BundlePopup(
    this.balance,
    this.bundleBalance,
    this.active, {
    Key key,
    Duration refreshRate = const Duration(minutes: 1),
  }) : super(key: key, refreshRate: refreshRate);
  final parser = EmojiParser();
  final Balance balance;
  final ActiveBundle bundleBalance;
  final List<ActiveBundle> active;
  @override
  Widget build(BuildContext context) {
    if (bundleBalance != null &&
        bundleBalance.expiry
                .compareTo(DateTime.now().add(Duration(seconds: 0))) ==
            0) Get.find<BundlesController>().scheduleRefresh();
    return active.length > 0
        ? PopupMenuButton<Object>(
            child: Container(
                width: 150,
                height: 25,
                child: Center(
                    child: Text(
                        "${active.length} ${parser.emojify(":package:")} ${bundleBalance.toShortString()}"))),
            offset: Offset(0, 250),
            itemBuilder: (context) {
              List widgets = active
                  .map(
                    (b) => PopupMenuItem(
                      child: Text(b.toString()),
                    ),
                  )
                  .toList();
              widgets.add(PopupMenuItem(
                child: Text("Balance: ${balance.amount}"),
              ));
              return widgets;
            })
        : Center(child: Text("${balance.amount}"));
  }
}
