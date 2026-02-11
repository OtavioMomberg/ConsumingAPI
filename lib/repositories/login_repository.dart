import 'package:tomate_shop/models/input_models/login_model.dart';
import 'package:tomate_shop/models/output_models/login_output_model.dart';

abstract class LoginRepository {
  Future<LoginOutputModel?> loginUser(LoginModel loginModel);
}