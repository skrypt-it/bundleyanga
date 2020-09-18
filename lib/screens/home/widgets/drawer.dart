import 'package:bundle_yanga/controllers/auth_controller.dart';
import 'package:bundle_yanga/screens/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bundle_yanga/screens/login/login.dart';
import 'package:bundle_yanga/widgets/oval-clipper.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Divider _buildDivider() {
      return Divider(
        color: Theme.of(context).accentColor,
      );
    }

    contact() async {
      const url = 'https://wa.me/265881446998';
      const siteUrl = 'https://skrypt.it/contact';
      if (await canLaunch(url)) {
        await launch(url);
        // } else if (await canLaunch(siteUrl)) {
        //   await launch(siteUrl);
      } else {
        Get.snackbar("Error", "Could not launch $siteUrl",
            colorText: Colors.white,
            backgroundColor: Theme.of(context).errorColor);
      }
    }

    openWebsite() async {
      const siteUrl = 'https://skrypt.it/apps/bundle-yanga';
      if (await canLaunch(siteUrl)) {
        await launch(siteUrl);
      } else {
        Get.snackbar("Error", "Could not launch $siteUrl",
            colorText: Colors.white,
            backgroundColor: Theme.of(context).errorColor);
      }
    }

    openSource() async {
      const siteUrl = 'https://github.com/skrypt-co/bundleyanga';
      if (await canLaunch(siteUrl)) {
        await launch(siteUrl);
      } else {
        Get.snackbar("Error", "Could not launch $siteUrl",
            colorText: Colors.white,
            backgroundColor: Theme.of(context).errorColor);
      }
    }

    Widget _buildRow(IconData icon, String title, onTap) {
      final TextStyle tStyle =
          TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0);
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(children: [
            Icon(
              icon,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(width: 10.0),
            Text(
              title,
              style: tStyle,
            ),
          ]),
        ),
      );
    }

    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60.0),
                _buildDivider(),
                _buildRow(Icons.settings, "Settings", () {
                  Navigator.pop(context);
                  Get.to(Settings());
                }),
                _buildDivider(),
                _buildRow(Icons.power_settings_new, "Log Out", () async {
                  Get.find<AuthController>().logout();
                }),
                // _buildRow(Icons.info_outline, "Help", null),
                _buildDivider(),
                Spacer(),
                Text(
                  "This is an unofficial TNM Dynamic Bundle App",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                Text(
                  "Developed By Skrypt",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                _buildDivider(),
                _buildRow(Icons.email, "Contact Developer", () => contact()),
                _buildDivider(),
                _buildRow(Icons.link, "Visit Website", () => openWebsite()),
                _buildDivider(),
                _buildRow(Icons.code, "Source", () => openSource()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
