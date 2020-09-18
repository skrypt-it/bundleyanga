import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                // _key.currentState.openDrawer();
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).accentColor,
              ),
            ),
            Text(
              "Bundle Yanga",
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 24),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
