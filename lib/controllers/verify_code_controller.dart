import 'package:tomate_shop/models/input_models/verify_code_model.dart';
import 'package:tomate_shop/repositories/verify_code_repository.dart';

class VerifyCodeController {
  final VerifyCodeRepository verifyCodeRepository;

  VerifyCodeController(this.verifyCodeRepository);

  String? _errorVerifyCode;

  String? get getErrorVerifyCode => _errorVerifyCode;

  Future<void> onVerifyCode(VerifyCodeModel verifyCodeModel) async {
    _errorVerifyCode = null;
    try {
      await verifyCodeRepository.verifyCode(verifyCodeModel);

    } catch(error) {
      List<String> split = error.toString().split('"');
      _errorVerifyCode = split[split.length-2];
    }
  }
}