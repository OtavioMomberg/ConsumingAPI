import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/models/output_models/refresh_token_model.dart';
import 'package:tomate_shop/repositories/refresh_repository.dart';

class RefreshController {
  final RefreshRepository refreshRepository;
  final AuthServices authServices;

  RefreshController(this.refreshRepository, this.authServices);

  String? _errorToken;

  String? get getErrorToken => _errorToken;

  RefreshTokenModel? _refreshTokenModel;

  RefreshTokenModel? get getRefreshTokenModel => _refreshTokenModel;

  Future<void> getAccessToken(String refreshToken) async {
    _errorToken = null;
    try {
      final token = await refreshRepository.getNewAccessToken(refreshToken);

      if (token != null) _refreshTokenModel = token;
    
      final tokenType = TokenTypeEnum.mapper(TokenType.accessToken);
      await authServices.saveToken(token!.newAccessToken, tokenType);
    } catch(error) {
      _errorToken = "Error in the operation: ${error.toString()}";
    }
  }
}