import 'package:flutter/material.dart';
import '../auth/verify_tokens.dart';
import '../enums/auth_enum.dart';
import '../enums/token_type_enum.dart';
import '../widgets/bottom_bar.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({super.key});

  @override
  State<RoutingPage> createState() => RoutingPageState();
}

class RoutingPageState extends State<RoutingPage> {
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();
  final GlobalKey<CartPageState> _cartKey = GlobalKey<CartPageState>();
  final GlobalKey<OrdersPageState> _orderKey = GlobalKey<OrdersPageState>();
  final GlobalKey<ProfilePageState> _profileKey = GlobalKey<ProfilePageState>();
  final _verifyTokens = VerifyTokens();
  late String tokenType;
  late String? _auth;
  final Map<String, IconData> iconButtons = {
    "Home": Icons.home,
    "Cart": Icons.shopping_cart,
    "Orders": Icons.receipt_long,
    "Profile": Icons.person,
  };
  final List<bool> controllButtons = [true, false, false, false];
  int value = 0;
  bool hideBottomBar = false;
  bool authCheck = false;
  String? responseLogin = "";
  int lastIndex = 0;

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
    return SafeArea(
      top: false,
      child: Stack(
        fit: StackFit.loose,
        children: [
          IndexedStack(
            index: value,
            sizing: StackFit.expand,
            children: [
              HomePage(key: _homeKey),
              CartPage(key: _cartKey),
              OrdersPage(key: _orderKey),
              ProfilePage(resetToHome: () async => await switchTab(0), key: _profileKey),
            ],
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            child: GestureDetector(
              child: BottomBar(
                iconButtons: iconButtons,
                controllButtons: controllButtons,
                switchTab: switchTab,
              ),
            ),    
          ),
        ],
      ),
    );
  }

  bool isProtected(int index) {
    return index > 0 ? true : false;
  }

  Future<void> switchTab(int index) async {
    if (lastIndex == index) return;
    int rollBackIndex = lastIndex;

    setState(() {
      for (int i = 0; i < controllButtons.length; i++) {
        if (controllButtons[i] == true) {
          controllButtons[i] = false;
          break;
        }
      }
      controllButtons[index] = !controllButtons[index];
      value = index;
      lastIndex = index;
    });

    if (isProtected(index)) {
      await loadAuth();
      if (!authCheck) {
        await _goToLogin();
        if (responseLogin == "" || responseLogin == null) {
          await _rollBack(rollBackIndex);
          return;
        }
      }
    }
    goToNextPage(index);
  }

  Future<void> loadAuth() async {
    _auth = await _verifyTokens.checkAccessToken(
      TokenTypeEnum.mapper(TokenType.accessToken),
    );
    if (_auth == MapAuthEnum.mapper(AuthEnum.authenticated)) {
      authCheck = true;
    } else {
      authCheck = false;
    }
  }

  Future<void> _goToLogin() async {
    responseLogin = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginPage();
        },
      ),
    );
  }

  Future<void> goToNextPage(int index) async {
    if (index == 0) {
      _homeKey.currentState?.loadProducts();
    }

    if (index == 1) {
      _cartKey.currentState?.loadItens();
      return;
    }

    if (index == 2) {
      _orderKey.currentState?.loadOrders();
      return;
    }

    if (index == 3) {
      _profileKey.currentState?.loadProfile();
      return;
    }
  }

  Future<void> _rollBack(int index) async {
    setState(() {
      for (int i = 0; i < controllButtons.length; i++) {
        if (controllButtons[i] == true) {
          controllButtons[i] = false;
          break;
        }
      }
      controllButtons[index] = !controllButtons[index];
      value = index;
      lastIndex = index;
    });
  }
}
