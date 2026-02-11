import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/auth/verify_tokens.dart';
import 'package:tomate_shop/controllers/update_uset_controller.dart';
import 'package:tomate_shop/models/input_models/update_user_model.dart';
import 'package:tomate_shop/repositories/implementarions/update_user_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';
import 'package:tomate_shop/widgets/input_fields/basic_input.dart';
import '../enums/auth_enum.dart';
import '../enums/token_type_enum.dart';

class UpdateUserPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const UpdateUserPage({required this.user, super.key});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  late final UpdateUsetController updateUsetController;
  final VerifyTokens _verifyTokens = VerifyTokens();
  final AuthServices _authServices = AuthServices();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final streetController = TextEditingController();
  final numberController = TextEditingController();

  late String? _auth;
  late String? token;

  @override
  void initState() {
    super.initState();

    updateUsetController = UpdateUsetController(
      UpdateUserImplementationHttp(client: Client()),
    );

    nameController.text = widget.user["name"];
    emailController.text = widget.user["email"];
    countryController.text = widget.user["country"];
    stateController.text = widget.user["state"];
    cityController.text = widget.user["city"];
    neighborhoodController.text = widget.user["neighborhood"];
    streetController.text = widget.user["street"]; 
    numberController.text = widget.user["number"]; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 240, 174),
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
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
          height: size.height * 0.9,
          width: size.width * 0.9,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            color: Colors.white.withValues(alpha: 0.2),
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
                      BasicInput(controller: nameController, hint: "Name", icon: Icons.person),
                      BasicInput(controller: emailController, hint: "Email", icon: Icons.email),
                      BasicInput(controller: countryController, hint: "Country", icon: Icons.public),
                      BasicInput(controller: stateController, hint: "State", icon: Icons.location_on),
                      BasicInput(controller: cityController, hint: "City", icon: Icons.location_city),
                      BasicInput(controller: neighborhoodController, hint: "Neighborhood", icon: Icons.home_work),
                      BasicInput(controller: streetController, hint: "Street", icon: Icons.signpost),
                      BasicInput(controller: numberController, hint: "Number", icon: Icons.numbers),
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
                        Button(buttonText: "Save", function: _updateUser),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateUser() async {
    final check = await checkToken();

    if (check) {
      final UpdateUserModel userModel = UpdateUserModel(
        name: nameController.text, 
        email: emailController.text, 
        country: countryController.text, 
        state: stateController.text, 
        city: cityController.text, 
        neighborhood: neighborhoodController.text, 
        street: streetController.text, 
        number: numberController.text,
      );

      token = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));
      await updateUsetController.onUpdateUser(token!, userModel);
      
      if (updateUsetController.getErrorUpdateUser == null) {
        await showMessage(true);

        if (!mounted) return;
        Navigator.pop(context);
      } else {
        showMessage(false, updateUsetController.getErrorUpdateUser!);
      }
    }
  }

  Future<bool> checkToken() async {
    _auth = await _verifyTokens.checkAccessToken(TokenTypeEnum.mapper(TokenType.accessToken));

    if (_auth == MapAuthEnum.mapper(AuthEnum.authenticated)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> showMessage(bool result, [String? response]) async {
    await showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text(result ? "Sucess" : "Error", style: TextStyle(color: const Color.fromARGB(255, 249, 169, 125))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"),),
        ],      
        content: Text(response ?? "User details updated successfully", style: TextStyle(color: const Color.fromARGB(255, 249, 169, 125))),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    neighborhoodController.dispose(); 
    streetController.dispose(); 
    numberController.dispose(); 
    super.dispose();
  }
}