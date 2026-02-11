import 'package:tomate_shop/models/output_models/forgot_password_model.dart';
import 'package:tomate_shop/repositories/forgot_password_repository.dart';

class ForgotPasswordController {
  final ForgotPasswordRepository forgotPasswordRepository;

  ForgotPasswordController(this.forgotPasswordRepository);

  String? _errorForgotPassword;

  String? get getErrorForgotPassword => _errorForgotPassword;

  ForgotPasswordModel? _forgotPasswordModel;

  ForgotPasswordModel? get getForgotPasswordModel => _forgotPasswordModel;

  Future<void> onForgetPassword(String email) async {
    _errorForgotPassword = null;
    try {
      final response = await forgotPasswordRepository.forgotPasswordRepository(email);

      if (response != null) _forgotPasswordModel = response;

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorForgotPassword = split[split.length-2];
    }
  }
}