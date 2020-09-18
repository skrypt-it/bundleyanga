import 'package:bundle_yanga/controllers/bundles.dart';
import 'package:bundle_yanga/models/bundle.dart';
import 'package:bundle_yanga/models/bundles.dart';
import 'package:bundle_yanga/screens/home/widgets/bundle_status.dart';
import 'package:bundle_yanga/screens/home/widgets/bundle_tile.dart';
import 'package:bundle_yanga/widgets/dialog.dart';
import 'package:bundle_yanga/widgets/fcb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BundleList extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();
  final BundleType type;

  BundleList({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final BundlesController state = Get.find();
    return Obx(() {
      return FutureContent<Bundles>(
          future: state.bundles.value,
          builder: (context, value) {
            List list = type == BundleType.data
                ? value.list.where((element) => element.data).toList()
                : value.list.where((element) => !element.data).toList();
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: () async {
                state.checkBalance();
                await state.checkYanga();
                _refreshController.refreshCompleted();
              },
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    Bundle bundle = list[index];
                    return BundleTile(
                        bundle: list[index],
                        onPressed: () => Get.dialog(BeautifulAlertDialog(
                            title: bundle.data
                                ? "Buy Data Bundle"
                                : "Buy Voice Bundle",
                            question: "Would you like to buy this bundle?",
                            headline: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bundle.unit == "Minutes"
                                      ? "${bundle.size}min"
                                      : "${bundle.size}${bundle.unit}",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                Text(
                                  "@ K${bundle.price}",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text("${bundle.percent}%",
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            accept: () => state.buyBundle(list[index]),
                            decline: () {})));
                  }),
            );
          });
    });
  }
}
