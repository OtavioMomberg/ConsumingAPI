import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/models/input_models/login_model.dart';
import 'package:tomate_shop/models/output_models/login_output_model.dart';
import 'package:tomate_shop/repositories/login_repository.dart';

class LoginController {
  final LoginRepository loginRepository;
  final AuthServices authServices;

  LoginController(this.loginRepository, this.authServices);

  String? _errorLogin = "";

  String? get getErrorLogin => _errorLogin;

  LoginOutputModel? _loginOutputModel;

  LoginOutputModel? get getLoginOutputModel => _loginOutputModel;

  Future<void> onLoginUser(LoginModel loginModel) async {
    _errorLogin = null;
    try {
      final response = await loginRepository.loginUser(loginModel);
      _loginOutputModel = response;

      if (_loginOutputModel?.accessToken != null) {
        authServices.saveToken(_loginOutputModel!.accessToken, "access_token");
      }
      if (_loginOutputModel?.refreshToken != null) {
        authServices.saveToken(_loginOutputModel!.refreshToken, "refresh_token");
      }
    } catch (error) {
      List<String> split = error.toString().split('"');
      _errorLogin = split[split.length-2];
    }
  }
}
