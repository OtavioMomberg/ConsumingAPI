import 'package:flutter/material.dart';

class BasicInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const BasicInput({
    required this.controller, 
    required this.hint,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hint: Text(
          hint,
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