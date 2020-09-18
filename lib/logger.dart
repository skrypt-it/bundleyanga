import 'dart:convert';
import 'package:bundle_yanga/secrets.dart';
import 'package:bundle_yanga/services/handler.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as Http;
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Logger with Handler {
  final Map<String, String> headers = {
    'Authorization': "Bearer $LOG_KEY",
    'Content-Type': 'application/json'
  };
  final String logUrl = "https://logs.timber.io/sources/$LOG_SOURCE/frames";
  final deviceInfo;
  Logger({this.deviceInfo});

  static Future<Logger> init() async {
    DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
    var deviceInfo;
    if (Platform.isAndroid) {
      deviceInfo = await _deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      deviceInfo = await _deviceInfo.iosInfo;
    }
    return Logger(deviceInfo: deviceInfo);
  }

  void log(message) {
    Map<String, dynamic> body = {
      "level": "info",
      "message": message,
      "device": encodeDeviceInfo(deviceInfo)
    };
    sendLog(body, true);
  }

  void event(String name, Map<String, String> data) {
    Map<String, dynamic> body = {
      "level": "info",
      "message": "$name",
      "data": data,
      "device": encodeDeviceInfo(deviceInfo)
    };
    sendLog(body, true);
  }

  void debug(String message, Map<String, String> data) {
    Map<String, dynamic> body = {
      "level": "debug",
      "message": "$message",
      "data": data,
      "device": encodeDeviceInfo(deviceInfo)
    };
    sendLog(body, true);
  }

  void warn(String message, Map<String, String> data) {
    Map<String, dynamic> body = {
      "level": "warn",
      "message": "$message",
      "data": data,
      "device": encodeDeviceInfo(deviceInfo)
    };
    sendLog(body, true);
  }

  void error(String message, Map<String, String> data) {
    Map<String, dynamic> body = {
      "level": "error",
      "message": "$message",
      "data": data,
      "device": encodeDeviceInfo(deviceInfo)
    };
    sendLog(body, true);
  }

  Future<bool> sendLog(Map<String, dynamic> body, bool save,
      {String date}) async {
    return handle(
            Http.post(logUrl, body: jsonEncode(body), headers: headers)
                .timeout(const Duration(seconds: 10)),
            type: 'asd')
        .then((value) => true)
        .catchError((e) => false);
  }

  void saveLog(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> logs = prefs.getStringList('logs') ?? [];
    logs.insert(
        0, jsonEncode({"date": new DateTime.now().toString(), "body": body}));
    await prefs.setStringList('logs', logs);
  }

  syncLogs() async {
    // TODO:
  }
}

Map<String, String> encodeDeviceInfo(deviceInfo) {
  if (deviceInfo is IosDeviceInfo) {
    return {
      "model": deviceInfo.model,
      "name": deviceInfo.name,
      "systemVersion": deviceInfo.systemVersion,
      "machine": deviceInfo.utsname.machine,
      "release": deviceInfo.utsname.release,
      "sysname": deviceInfo.utsname.sysname,
    };
  }
  if (deviceInfo is AndroidDeviceInfo) {
    return {
      "androidId": deviceInfo.androidId,
      "brand": deviceInfo.brand,
      "device": deviceInfo.device,
      "model": deviceInfo.model,
      "release": deviceInfo.version.release,
      "codename": deviceInfo.version.codename,
    };
  }
  return {};
}
