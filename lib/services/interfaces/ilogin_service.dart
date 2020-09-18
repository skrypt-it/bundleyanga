abstract class ILoginService {
  Future<AuthResponse> login(String identifier, String password);
  Future<AuthResponse> register(formData);
  Future<AuthResponse> requestPassword(formData);
  Future<AuthResponse> verify(formData);
  Future<AuthResponse> updatePassword(formData);
}

class AuthRequestResponse {
  final String error;
  final String token;
  final Map errorDetails;
  AuthRequestResponse({this.errorDetails, this.error, this.token});
  factory AuthRequestResponse.fromMap(map) {
    return AuthRequestResponse(
        error: map['error'] != null ? map['error']['message'] : null,
        errorDetails: map['error'] != null ? map['error']['details'] : null,
        token: map['token'] ?? null);
  }
  @override
  String toString() {
    return token != null ? "Auth token:  $token" : "Auth Error: $error";
  }
}

class AuthResponse {
  final bool isLoggedIn;
  final String error;
  final String token;

  AuthResponse(this.isLoggedIn, {this.error, this.token});
}
