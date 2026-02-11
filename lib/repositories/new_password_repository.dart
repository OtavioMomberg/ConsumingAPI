import 'package:tomate_shop/models/input_models/new_password_model.dart';

abstract class NewPasswordRepository {
  Future<void> newPassword(NewPasswordModel newPasswordModel);
}
