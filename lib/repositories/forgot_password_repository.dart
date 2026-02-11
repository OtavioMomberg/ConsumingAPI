import 'package:tomate_shop/models/output_models/forgot_password_model.dart';

abstract class ForgotPasswordRepository {
  Future<ForgotPasswordModel?> forgotPasswordRepository(String email);
}