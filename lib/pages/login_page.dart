import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/controllers/login_controller.dart';
import 'package:tomate_shop/models/input_models/login_model.dart';
import 'package:tomate_shop/pages/create_account_page.dart';
import 'package:tomate_shop/pages/forgotPassword/forgot_password_page.dart';
import 'package:tomate_shop/repositories/implementarions/login_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/create_account_button.dart';
import 'package:tomate_shop/widgets/buttons/forgot_password_button.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/input_fields/basic_Input.dart';
import 'package:tomate_shop/widgets/input_fields/password_input.dart';

class LoginPage extends StatefulWidget {
  final bool? returnMain;
  const LoginPage({this.returnMain, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController _loginController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    _loginController = LoginController(
      LoginImplementationHttp(client: Client()),
      AuthServices(),
    );
    super.initState();
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
    return SafeArea(
      top: false,
      child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 20,
                      children: <Widget>[
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        BasicInput(
                          controller: _emailController,
                          hint: "Email",
                          icon: Icons.email,
                        ),
                        PasswordInput(controller: _passwordController),
                        ForgotPasswordButton(
                          forgotPassword: _forgotPassword,
                        ),
                        Button(buttonText: "Login", function: _login),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox.expand(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CreateAccountButton(signUp: _signUp),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage("Some fields are not filled.");
      return;
    }

    LoginModel loginModel = LoginModel(
      email: _emailController.text,
      password: _passwordController.text,
    );

    await _loginController.onLoginUser(loginModel);

    if (_loginController.getErrorLogin != null) {
      _showMessage(_loginController.getErrorLogin!);
      return;
    } 

    if (widget.returnMain == null) {
      returnPreviousPage("Success");
    } else {
      if (!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    
  }

  void returnPreviousPage(String? response) {
    Navigator.pop(context, response);
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return CreateAccountPage();
        },
      ),
    );
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ForgotPasswordPage();
        },
      ),
    );
  }
  
  void _showMessage(String message) {
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Error", 
          style: TextStyle(
            color: Color.fromARGB(255, 249, 169, 125), 
            fontWeight: FontWeight.bold, fontSize: 20
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text(
              "OK",
              style: TextStyle(
                color: Color.fromARGB(255, 249, 169, 125),  
              ),
            ),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Text(
                message, 
                style: TextStyle(
                  color: const Color.fromARGB(255, 249, 169, 125), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
