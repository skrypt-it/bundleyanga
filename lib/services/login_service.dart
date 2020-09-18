import 'package:bundle_yanga/logger.dart';
import 'package:bundle_yanga/services/handler.dart';
import 'package:bundle_yanga/services/interfaces/ilogin_service.dart';
import 'package:http/http.dart' as Http;
import 'dart:async';

class Req {
  final String url;
  final String method;

  Req({this.method, this.url});
}

class Config {
  final String origin;
  final Req login;
  final Req verify;

  Config({this.origin, this.login, this.verify});
}

class LoginService with Handler implements ILoginService {
  Config config = Config(
    origin: 'https://yangabundles.tnm.co.mw/ccc-p/',
    login: Req(method: 'post', url: 'st/verify'),
    verify: Req(method: 'post', url: 'st/confirm'),
  );
  final Logger logger;

  LoginService(this.logger);
  Future<AuthResponse> login(String identifier, String password) {
    String phone = identifier;
    try {
      int.tryParse(phone);
    } catch (e) {
      throw new FormatException();
    }
    return handle(Http.post("${config.origin}${config.login.url}",
                body: "{'extras': {}, 'msisdn': 265$phone}")
            .timeout(const Duration(seconds: 10)))
        .then((res) {
      if (res['status'] == 1) {
        return AuthResponse(true);
      }
      return AuthResponse(false, error: 'Something happened');
    }).catchError((e) {
      return AuthResponse(false, error: e.toString());
    });
  }

  Future<AuthResponse> verify(formData) {
    String phone = formData['phone'];
    String otp = formData['otp'];
    return handle(Http.post("${config.origin}${config.verify.url}",
                body: "{'code': $otp, 'msisdn': 265$phone}")
            .timeout(const Duration(seconds: 10)))
        .then((res) {
      if (res['status'] == 1) {
        return AuthResponse(true, token: res['data']['token']);
      }
      return AuthResponse(false, error: "OTP doesn't match");
    }).catchError((e) {
      return AuthResponse(false, error: e.toString());
    });
  }

  @override
  Future<AuthResponse> register(formData) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> requestPassword(formData) {
    // TODO: implement requestPassword
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> updatePassword(formData) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }
}
