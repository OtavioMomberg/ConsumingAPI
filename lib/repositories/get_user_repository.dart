import 'package:tomate_shop/models/output_models/get_user_model.dart';

abstract class GetUserRepository {
  Future<GetUserModel?> getUser(String accessToken);
}