import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/controllers/forgot_password_controller.dart';
import 'package:tomate_shop/pages/forgotPassword/verify_code_page.dart';
import 'package:tomate_shop/repositories/implementarions/forgot_password_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/input_fields/basic_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final ForgotPasswordController forgotPasswordController;
  final _emailController = TextEditingController();
  String? code;

  @override
  void initState() {
    super.initState();

    forgotPasswordController = ForgotPasswordController(
      ForgotPasswordImplementationHttp(client: Client()),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  spacing: 20,
                  children: <Widget>[
                    const AutoSizeText(
                      "Forget Password",
                      maxFontSize: 40,
                      maxLines: 1,
                      minFontSize: 20,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BasicInput(controller: _emailController, hint: "Email", icon: Icons.email),
                    Button(buttonText: "Send", function: _sendEmail),
                  ],
                ),
              ),
              if (code != null)...{
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Your Code: $code",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (code! != forgotPasswordController.getErrorForgotPassword)
                          IconButton(onPressed: _copyCode, icon: Icon(Icons.copy, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Spacer(flex: 1),
              }
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendEmail() async {
    if (_emailController.text.isEmpty) return;
    await forgotPasswordController.onForgetPassword(_emailController.text);

    if (forgotPasswordController.getErrorForgotPassword != null) {
      code = forgotPasswordController.getErrorForgotPassword;  
    } else {
      code = forgotPasswordController.getForgotPasswordModel!.code;
    } 

    if (!mounted) return;

    setState(() {});
  }

  void _copyCode() async {
    if (code != null) {
      Clipboard.setData(ClipboardData(text: code!));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text copied to clipboard!')),
      );

      await Future.delayed(Duration(seconds: 1));

      _goToVerifyCodePage();
    }
  }

  void _goToVerifyCodePage() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (BuildContext context) {
        return VerifyCodePage(userEmail: _emailController.text);
      }),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
