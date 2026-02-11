import 'package:tomate_shop/models/input_models/verify_code_model.dart';

abstract class VerifyCodeRepository {
  Future<void> verifyCode(VerifyCodeModel verifyCodeModel);
}