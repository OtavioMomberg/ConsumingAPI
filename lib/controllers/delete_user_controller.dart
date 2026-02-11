import 'package:tomate_shop/repositories/delete_user_repository.dart';

class DeleteUserController {
  final DeleteUserRepository deleteUserRepository;

  DeleteUserController(this.deleteUserRepository);

  String? _errorDeleteUser;

  String? get getErrorDeleteUser => _errorDeleteUser;

  Future<void> onDeleteUser(String accessToken) async {
    _errorDeleteUser = null;
    try {
      await deleteUserRepository.deleteUser(accessToken);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorDeleteUser = split[split.length-2];
    }
  }
}