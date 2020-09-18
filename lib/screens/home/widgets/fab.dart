import 'package:bundle_yanga/controllers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAB extends StatelessWidget {
  final NotificationsController notty = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => FloatingActionButton(
          onPressed: () => notty.toggle(),
          child: notty.status.value
              ? Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).accentColor,
                )
              : Icon(
                  Icons.notifications_off,
                  color: Theme.of(context).primaryColor,
                ),
          backgroundColor: notty.status.value
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
        ));
  }
}
