import 'package:bundle_yanga/controllers/login_controller.dart';
import 'package:bundle_yanga/logger.dart';
import 'package:bundle_yanga/screens/login/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phone = '';
  String otp = '';
  Logger logger;
  FocusNode phoneFocus = FocusNode();
  GlobalKey _otpKey = GlobalKey();
  GlobalKey _phoneKey = GlobalKey();
  FocusNode otpFocus = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  bool sent = false;

  @override
  Widget build(BuildContext context) {
    final state = Get.find<LoginController>();
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Stack(
          children: [
            Header(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 270,
                  ),
                  sent
                      ? Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextField(
                            key: _otpKey,
                            onChanged: (String value) {
                              setState(() {
                                otp = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            focusNode: otpFocus,
                            onSubmitted: (value) => confirmOTP(),
                            cursorColor: Theme.of(context).primaryColorDark,
                            decoration: InputDecoration(
                                hintText: "OTP",
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: Icon(
                                    Icons.confirmation_number,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 13)),
                          ),
                        )
                      : Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextField(
                              key: _phoneKey,
                              onChanged: (String value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) => sendOTP(),
                              focusNode: phoneFocus,
                              cursorColor: Theme.of(context).primaryColorDark,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 2.0),
                                  child: Text('+265'),
                                ),
                                prefixIcon: Material(
                                  elevation: 0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: Icon(
                                    Icons.phone,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                border: InputBorder.none,
                              )),
                        ),
                  SizedBox(
                    height: 25,
                  ),
                  sent
                      ? Obx(() => FutureBuilder(
                          future: state.verifyState.value,
                          builder: (context, _) => FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  "Verify OTP",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                disabledColor: Colors.grey,
                                color: Theme.of(context).primaryColor,
                                onPressed:
                                    _.connectionState == ConnectionState.waiting
                                        ? null
                                        : otp.length == 6 ? confirmOTP : null,
                              )))
                      : Obx(() => FutureBuilder(
                          future: state.loginState.value,
                          builder: (context, _) => FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  "Send OTP",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                ),
                                disabledColor: Colors.grey,
                                color: Theme.of(context).primaryColor,
                                onPressed:
                                    _.connectionState == ConnectionState.waiting
                                        ? null
                                        : phone.length == 9 ? sendOTP : null,
                              ))),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    "Bundle Yanga",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  )),
                  Links()
                ],
              ),
            ),
          ],
        ));
  }

  void sendOTP() {
    phoneFocus.unfocus();
    Get.find<LoginController>().login(phone).then((value) {
      setState(() {
        sent = value.isLoggedIn;
      });
    });
  }

  void confirmOTP() async {
    otpFocus.unfocus();
    Get.find<LoginController>().verify(otp).then((value) => null);
  }
}

class Links extends StatelessWidget {
  const Links({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return Column(
      children: [
        SizedBox(
          height: 70,
        ),
        Center(
          child: Column(
            children: [
              Text(
                "This is an unofficial TNM Dynamic Bundle App",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Developed By Skrypt",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton.icon(
                      onPressed: openWebsite,
                      icon: Icon(Icons.link,
                          color: Theme.of(context).primaryColor),
                      label: Text("Visit Website",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor))),
                  FlatButton.icon(
                      onPressed: contact,
                      icon: Icon(Icons.contact_phone,
                          color: Theme.of(context).primaryColor),
                      label: Text("Contact",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)))
                ],
              ),
              Text(
                "We 💚 Open Source",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              FlatButton.icon(
                  onPressed: openSource,
                  icon: Icon(Icons.code, color: Theme.of(context).primaryColor),
                  label: Text("Source",
                      style: TextStyle(color: Theme.of(context).primaryColor)))
            ],
          ),
        ),
      ],
    );
  }
}
