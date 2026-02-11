import 'package:tomate_shop/models/output_models/refresh_token_model.dart';

abstract class RefreshRepository {
  Future<RefreshTokenModel?> getNewAccessToken(String refreshToken);
}