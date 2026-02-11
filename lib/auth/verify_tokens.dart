import 'package:http/http.dart';
import 'package:tomate_shop/controllers/refresh_controller.dart';
import 'package:tomate_shop/enums/auth_enum.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/repositories/implementarions/refresh_implementation_http.dart';
import 'auth_services.dart';

class VerifyTokens {
  static final AuthServices _authServices = AuthServices();

  static final RefreshController _refreshController = RefreshController(
    RefreshImplementationHttp(client: Client()),
    _authServices,
  );

  Future<String> checkAccessToken(String tokenType) async { 
    final token = await _authServices.getToken(tokenType);

    if (token == null) {
      String tokenTypeRefresh = TokenTypeEnum.mapper(TokenType.refreshToken);
      final refreshToken = await _authServices.getToken(tokenTypeRefresh);
      if (refreshToken != null) {
        final auth = await getNewToken(refreshToken);
        return auth == MapAuthEnum.mapper(AuthEnum.notAuthenticated) 
          ? MapAuthEnum.mapper(AuthEnum.notAuthenticated) 
          : MapAuthEnum.mapper(AuthEnum.authenticated);
      } else {
        return MapAuthEnum.mapper(AuthEnum.notAuthenticated);
      }
    } else {
      return MapAuthEnum.mapper(AuthEnum.authenticated);
    }
  }

  Future<String?> getNewToken(String refreshToken) async {
    await _refreshController.getAccessToken(refreshToken);

    if (_refreshController.getErrorToken != null) {
      return MapAuthEnum.mapper(AuthEnum.notAuthenticated);
    }

    checkAccessToken(TokenTypeEnum.mapper(TokenType.accessToken));
    return null;
  }
}
