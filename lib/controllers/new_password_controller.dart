import 'package:tomate_shop/models/input_models/new_password_model.dart';
import 'package:tomate_shop/repositories/new_password_repository.dart';

class NewPasswordController {
  final NewPasswordRepository newPasswordRepository;

  NewPasswordController(this.newPasswordRepository);

  String? _errorNewPassword;

  String? get getErrorNewPassword => _errorNewPassword;

  Future<void> onNewPassword(NewPasswordModel newPasswordModel) async {
    _errorNewPassword = null;
    try {
      await newPasswordRepository.newPassword(newPasswordModel);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorNewPassword = split[split.length-2];
    }
  }
}