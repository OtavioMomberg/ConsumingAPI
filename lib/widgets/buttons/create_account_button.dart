import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final VoidCallback signUp;
  const CreateAccountButton({required this.signUp, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: signUp, 
          child: const Text(
            "Don't have an account? Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}