import 'package:bundle_yanga/screens/settings/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class Settings extends StatefulWidget {
  Settings();
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int minPercent = 50;
  int interval = 15;
  bool expiryReminder = true;
  String intervalString = '15 Minutes';
  String percentString = '50%';

  @override
  initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 150),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Notification Interval"),
                          Container(
                            width: 10,
                          ),
                          DropdownButton<String>(
                            items: <String>[
                              '15 Minutes',
                              '30 Minutes',
                              '45 Minutes',
                              'Hourly'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: intervalString,
                            onChanged: _updateInterval,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Minimim Discount"),
                          Container(
                            width: 10,
                          ),
                          DropdownButton<String>(
                            items: <String>[
                              '25%',
                              '35%',
                              '50%',
                              '65%',
                              '75%',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: percentString,
                            onChanged: _updatePercentage,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Text("Expiry Reminder"),
                          Checkbox(
                            value: expiryReminder,
                            onChanged: _updateReminder,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Header(),
            ],
          ),
        ),
      ),
    );
  }

  Future _updateReminder(val) async {
    setState(() {
      expiryReminder = val;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('expiryReminder', expiryReminder);
  }

  Future _updatePercentage(val) async {
    setState(() {
      switch (val) {
        case '25%':
          minPercent = 25;
          break;
        case '35%':
          minPercent = 35;
          break;
        case '50%':
          minPercent = 50;
          break;
        case '65%':
          minPercent = 65;
          break;
        case '75%':
          minPercent = 75;
          break;
        default:
          minPercent = 50;
      }
      percentString = val;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('minPercent', minPercent);
  }

  Future _updateInterval(val) async {
    setState(() {
      switch (val) {
        case '15 Minutes':
          interval = 15;
          break;
        case '30 Minutes':
          interval = 30;
          break;
        case '45 Minutes':
          interval = 45;
          break;
        case 'Hourly':
          interval = 60;
          break;
        default:
          interval = 15;
      }
      intervalString = val;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('interval', interval);
  }

  void initSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minPercent = prefs.getInt('minPercent') ?? 50;
      percentString = "$minPercent%";
      interval = prefs.getInt('interval') ?? 15;
      intervalString = interval < 60 ? "$interval Minutes" : "Hourly";
      expiryReminder = prefs.getBool('expiryReminder') ?? true;
    });
  }
}
