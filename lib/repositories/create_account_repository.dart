import 'package:tomate_shop/models/input_models/create_account_model.dart';

abstract class CreateAccountRepository {
  Future<void> registerAccount(CreateAccountModel createAccountModel);
}