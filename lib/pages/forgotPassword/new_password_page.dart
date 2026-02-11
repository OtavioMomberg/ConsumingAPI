import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/controllers/new_password_controller.dart';
import 'package:tomate_shop/models/input_models/new_password_model.dart';
import 'package:tomate_shop/pages/login_page.dart';
import 'package:tomate_shop/repositories/implementarions/new_password_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/input_fields/password_input.dart';

class NewPasswordPage extends StatefulWidget {
  final String userEmail;
  const NewPasswordPage({required this.userEmail, super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  late final NewPasswordController newPasswordController;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    newPasswordController = NewPasswordController(
      NewPasswordImplementationHttp(client: Client()),
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
      backgroundColor: Colors.white,
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
            borderRadius: BorderRadius.circular(12),
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
              PasswordInput(text: "New Password", controller: _newPasswordController),
              PasswordInput(text: "Confirm Password", controller: _confirmPasswordController),
              const SizedBox(height: 10),
              Button(buttonText: "Save", function: _newPassword),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _newPassword() async {
    NewPasswordModel newPasswordModel = NewPasswordModel(
      userEmail: widget.userEmail, 
      newPassword: _newPasswordController.text, 
      confirmPassword: _confirmPasswordController.text
    );
    
    await newPasswordController.onNewPassword(newPasswordModel);

    if (newPasswordController.getErrorNewPassword == null) {
      _showMessage("Password updated successfully!");

      await Future.delayed(Duration(seconds: 1));
      
      _goToLogin();
      
    } else {
      _showMessage(newPasswordController.getErrorNewPassword!);
    }
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage(returnMain: true);
      }),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}