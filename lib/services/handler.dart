import 'dart:async';
import 'dart:io';
import 'package:bundle_yanga/logger.dart';
import 'package:http/http.dart' as Http;
import 'dart:convert';

mixin Handler {
  Logger logger;
  Future<Map> handle(Future function, {String type = ''}) async {
    try {
      Http.Response response = await function;
      if (response.body.startsWith('[') || response.body.startsWith('{')) {
        Map info = jsonDecode(response.body);
        return info;
      }
      return {'response': response};
    } on HandshakeException catch (e) {
      logger.debug('Request exception', {"error": e.toString(), "type": type});
      return Future.error("Oops, something happened...");
    } on TimeoutException catch (e) {
      logger.debug('Request exception', {"error": e.toString(), "type": type});
      return Future.error('Timeout: Failed to connect to the server...');
    } on SocketException catch (e) {
      logger.debug('Request exception', {"error": e.toString(), "type": type});
      return Future.error("Could not connect to the server...");
    } on Error catch (e) {
      logger.debug('Request exception', {"error": e.toString(), "type": type});
      return Future.error("Oops, something happened...");
    }
  }
}
