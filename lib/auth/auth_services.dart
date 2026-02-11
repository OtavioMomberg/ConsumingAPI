import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';

// ignore: constant_identifier_names
const int MINUTES = 30;
// ignore: constant_identifier_names
const int DAYS = 7;

class AuthServices {
  final _storage = FlutterSecureStorage(aOptions: AndroidOptions());

  Future<void> saveToken(String token, String tokenType) async {
    DateTime time = DateTime.now();
    await _storage.write(key: tokenType, value: token);
    await _storage.write(key: "${tokenType}_expiration_time", value: time.toIso8601String());
  }

  Future<void> deleteToken(String tokenType) async {
    await _storage.delete(key: tokenType);
    await _storage.delete(key: "${tokenType}_expiration_time");
  }

  Future<String?> getToken(String tokenType) async {
    String? time = await _storage.read(key: "${tokenType}_expiration_time");

    if (time == null) return null;
    
    final token = TokenTypeEnum.mapper(TokenType.accessToken);
    final Duration duration = tokenType == token ? Duration(minutes: MINUTES) : Duration(days: DAYS);

    if (DateTime.now().difference(DateTime.parse(time)) >= duration) {
      await deleteToken(tokenType);
      return null;
    }
    return await _storage.read(key: tokenType);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}
