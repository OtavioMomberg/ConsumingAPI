import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  const PasswordInput({required this.controller, this.text, super.key});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isVisible,
      controller: widget.controller,
      cursorColor: Colors.white,

      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          onPressed: () => setState(() => isVisible = !isVisible), 
          icon: isVisible 
            ? Icon(Icons.visibility_off, color: Colors.white)
            : Icon(Icons.visibility, color: Colors.white)
        ),

        hint: Text(
          widget.text ?? "Password",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.white.withValues(alpha: 0.3), 
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.white.withValues(alpha: 0.3), 
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.white.withValues(alpha: 0.3), 
          ),
        ),
      ),
    );
  }
}