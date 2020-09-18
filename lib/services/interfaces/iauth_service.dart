abstract class IAuthService {
  Future<void> persistLogin(token, phone);
  Future<bool> isLoggedIn();
  Future<String> getToken();
  Future<String> getPhone();
  Future<void> logout();
}
