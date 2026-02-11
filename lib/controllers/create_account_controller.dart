import 'package:tomate_shop/models/input_models/create_account_model.dart';
import 'package:tomate_shop/repositories/create_account_repository.dart';

class CreateAccountController {
  final CreateAccountRepository createAccountRepository;

  CreateAccountController(this.createAccountRepository);

  String? _errorCreateAccount;

  String? get getErrorCreateAccount => _errorCreateAccount;

  Future<void> onCreateAccount(CreateAccountModel createAccountModel) async {
    _errorCreateAccount = null;
    try {
      await createAccountRepository.registerAccount(createAccountModel);
    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorCreateAccount = split[split.length-2];
    }
  }
}