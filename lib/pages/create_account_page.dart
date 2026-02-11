import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/controllers/create_account_controller.dart';
import 'package:tomate_shop/models/input_models/create_account_model.dart';
import 'package:tomate_shop/repositories/implementarions/create_account_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/input_fields/basic_input.dart';
import 'package:tomate_shop/widgets/input_fields/password_input.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late CreateAccountController _createAccountController;
  late final List<TextEditingController> controllerList;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    _createAccountController = CreateAccountController(
      CreateAccountImplementationHttp(client: Client()),
    );

    controllerList = [
      _nameController,
      _emailController,
      _passwordController,
      _cpfController,
      _countryController,
      _stateController,
      _cityController,
      _neighborhoodController,
      _streetController,
      _numberController,
    ];

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
            ]
          )
        ),
        child: Center(
          child: Container(
            height: size.height * 0.9,
            width: size.width * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color.fromARGB(255, 222, 221, 221).withValues(alpha: 0.5)),
            ),
            child: Column(
              spacing: 10,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      children: <Widget>[
                        const Text(
                          "SignUp",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BasicInput(controller: _nameController, hint: "Username", icon: Icons.person),
                        BasicInput(controller: _emailController, hint: "Email", icon: Icons.email),
                        PasswordInput(controller: _passwordController),
                        BasicInput(controller: _cpfController, hint: "CPF", icon: Icons.badge),
                        BasicInput(controller: _countryController, hint: "Country", icon: Icons.public),
                        BasicInput(controller: _stateController, hint: "State", icon: Icons.location_on),
                        BasicInput(controller: _cityController, hint: "City", icon: Icons.location_city),
                        BasicInput(controller: _neighborhoodController, hint: "Neighborhood", icon: Icons.home_work),
                        BasicInput(controller: _streetController, hint: "Street", icon: Icons.signpost),
                        BasicInput(controller: _numberController, hint: "Number", icon: Icons.numbers),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white),
                Expanded(
                  flex: 1,
                  child: SizedBox.expand(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Button(buttonText: "SignUp", function: _createAccount)
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

  Future<void> _createAccount() async {
    final bool check = await _checkControllers();

    if (!check) {
      _showMessage("Some fields are not filled.");
      return;
    }
    
    final Map<String, String> address = {
      "country": _countryController.text,
      "state": _stateController.text,
      "city": _cityController.text,
      "neighborhood": _neighborhoodController.text,
      "street": _streetController.text,
      "number": _numberController.text,
    };

    CreateAccountModel createAccountModel = CreateAccountModel(
      userName: _nameController.text, 
      email: _emailController.text, 
      password: _passwordController.text, 
      cpf: _cpfController.text, 
      address: address,
    );
    
    await _createAccountController.onCreateAccount(createAccountModel);

    if (_createAccountController.getErrorCreateAccount != null) {
      await _showMessage(_createAccountController.getErrorCreateAccount!);
      return;
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<bool> _checkControllers() async {
    for (var i in controllerList) {
      if (i.text.isEmpty) return false;
    }
    return true;
  }

  Future<void> _showMessage(String message) async {
    await showDialog(
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
    for (final c in controllerList) {
      c.dispose();
    }
    super.dispose();
  }
}