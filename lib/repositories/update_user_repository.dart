import 'package:tomate_shop/models/input_models/update_user_model.dart';

abstract class UpdateUserRepository {
  Future<void> updateUser(String accessToken, UpdateUserModel updateUserModel);
}