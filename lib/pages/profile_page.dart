import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart';
import 'package:tomate_shop/auth/auth_services.dart';
import 'package:tomate_shop/auth/verify_tokens.dart';
import 'package:tomate_shop/controllers/delete_user_controller.dart';
import 'package:tomate_shop/controllers/get_user_controller.dart';
import 'package:tomate_shop/enums/auth_enum.dart';
import 'package:tomate_shop/enums/token_type_enum.dart';
import 'package:tomate_shop/pages/update_user_page.dart';
import 'package:tomate_shop/repositories/implementarions/delete_user_implementation_http.dart';
import 'package:tomate_shop/repositories/implementarions/get_user_implementation_http.dart';
import 'package:tomate_shop/widgets/buttons/button.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback resetToHome;
  const ProfilePage({required this.resetToHome, super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late final GetUserController getUserController;
  late final DeleteUserController deleteUserController;
  late final AuthServices _authServices;
  late String? _auth;
  late String? token;
  final VerifyTokens _verifyTokens = VerifyTokens();

  @override
  void initState() {
    super.initState();

    _authServices = AuthServices();

    getUserController = GetUserController(
      GetUserImplementationHttp(client: Client()),
    );

    deleteUserController = DeleteUserController(
      DeleteUserImplementationHttp(client: Client()),
    );

    loadProfile();
  }

  Future<bool> checkToken() async {
    _auth = await _verifyTokens.checkAccessToken(TokenTypeEnum.mapper(TokenType.accessToken));

    if (_auth == MapAuthEnum.mapper(AuthEnum.authenticated)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loadProfile() async {
    final check = await checkToken();

    if (check) {
      token = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));
      await getUserController.onGetUser(token!);
    } else {
      return;
    }
    setState(() {});
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
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 95),
      height: size.height,
      width: size.width,
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
      child: getUserController.getIsLoading 
        ? Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : getUserController.getErrorUser == null 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: <Widget>[
                AutoSizeText(
                  "Olá, ${getUserController.getUser?.user["name"].toString().toUpperCase() ?? ""}",
                  maxLines: 1,
                  minFontSize: 16,
                  maxFontSize: 30,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Divider(color: Colors.white),
                const Text(
                  "OPTIONS:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: size.height * 0.5,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: <Widget>[
                      Button(buttonText: "Edit Profile", function: _goEditPage),
                      Button(buttonText: "Delete Profile", function: _deleteUser),
                      Button(buttonText: "Logout", function: _logout),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text(getUserController.getErrorUser!),
            ),
    );
  }
  
  Future<void> _goEditPage() async {
    final check = await checkToken();

    if (check) {
      if (getUserController.getUser?.user == null) return;
      
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return UpdateUserPage(user: getUserController.getUser?.user ?? {"" : ""});
        }),
      ).then((_) async {
        await loadProfile();
      });
    } else {
      return;
    }
  }
  
  Future<void> _deleteUser() async {
    final check = await checkToken();

    if (check) {
      token = await _authServices.getToken(TokenTypeEnum.mapper(TokenType.accessToken));
      await deleteUserController.onDeleteUser(token!);

        if (deleteUserController.getErrorDeleteUser == null) {
          await _authServices.logout();
          widget.resetToHome();
        } else {
          _showMessage("Error", deleteUserController.getErrorDeleteUser!);
        }
    } else {
      return;
    }
  }

  Future<void> _showMessage(String title, String content) async {
    await showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: const TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: const Color.fromARGB(255, 254, 160, 109)),
            ),
          ],
        ),
        content: Text(content, style: const TextStyle(color: Color.fromARGB(255, 254, 160, 109))),
      ),
    );
  } 
  
  Future<void> _logout() async {
    await _authServices.logout();
    widget.resetToHome();
  }
}