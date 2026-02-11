import 'package:tomate_shop/models/output_models/get_user_model.dart';
import 'package:tomate_shop/repositories/get_user_repository.dart';

class GetUserController {
  final GetUserRepository getUserRepository;

  GetUserController(this.getUserRepository);

  String? _errorGetUser;

  String? get getErrorUser => _errorGetUser;

  bool _isLoading = true;

  bool get getIsLoading => _isLoading;

  GetUserModel? _getUserModel;

  GetUserModel? get getUser => _getUserModel;

  Future<void> onGetUser(String accessToken) async {
    _errorGetUser = null;
    _isLoading = true;
    try {
      final response = await getUserRepository.getUser(accessToken);

      if (response != null) _getUserModel = response;
      
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorGetUser = split[split.length-2];
    }
    _isLoading = false;
  }
}