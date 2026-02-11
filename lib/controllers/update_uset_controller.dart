import 'package:tomate_shop/models/input_models/update_user_model.dart';
import 'package:tomate_shop/repositories/update_user_repository.dart';

class UpdateUsetController {
  final UpdateUserRepository updateUserRepository;

  UpdateUsetController(this.updateUserRepository);

  String? _errorUpdateUser;

  String? get getErrorUpdateUser => _errorUpdateUser;

  Future<void> onUpdateUser(String accessToken, UpdateUserModel updateUserModel) async {
    _errorUpdateUser = null;
    try {
      await updateUserRepository.updateUser(accessToken, updateUserModel);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorUpdateUser = split[split.length-2];
    }
  }

}