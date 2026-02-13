import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/controllers/verify_code_controller.dart';
import 'package:tomate_shop/models/input_models/verify_code_model.dart';
import 'package:tomate_shop/pages/forgotPassword/new_password_page.dart';
import 'package:tomate_shop/repositories/implementarions/verify_code_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/input_fields/code_input.dart';

class VerifyCodePage extends StatefulWidget {
  final String userEmail;
  const VerifyCodePage({required this.userEmail, super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  late final VerifyCodeController verifyCodeController;
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    verifyCodeController = VerifyCodeController(
      VerifyCodeImplementationHttp(client: Client()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 240, 174),
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color.fromARGB(255, 255, 240, 174),
            Color.fromARGB(255, 249, 169, 125),
            Color.fromARGB(255, 254, 160, 109),
          ],
        ),
      ),
      child: Center(
        child: Container(
          height: size.height * 0.7,
          width: size.width * 0.9,
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            color: Colors.white.withValues(alpha: 0.2),
          ),
          child: Column(
            spacing: 20,
            children: <Widget>[
              const AutoSizeText(
                "Verify Code",
                maxFontSize: 40,
                maxLines: 1,
                minFontSize: 20,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              CodeInput(getCode: _pastFromClipboard),
              Button(buttonText: "Verify", function: _verifyCode),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _pastFromClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    _codeController.text = data?.text ?? "";
    return data?.text ?? "";
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) return;

    VerifyCodeModel verifyCodeModel = VerifyCodeModel(
      userEmail: widget.userEmail, 
      code: _codeController.text.trim(),
    );

    await verifyCodeController.onVerifyCode(verifyCodeModel);

    if (verifyCodeController.getErrorVerifyCode == null) {
      _showMessage("Code verified successfully");

      await Future.delayed(Duration(seconds: 1));

      _goToNewPasswordPage();
    } else {
      _showMessage(verifyCodeController.getErrorVerifyCode!);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  } 

  void _goToNewPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return NewPasswordPage(userEmail: widget.userEmail);
      }),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}