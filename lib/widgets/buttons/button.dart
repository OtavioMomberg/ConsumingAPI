import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final Future<void> Function() function;
  final String buttonText;
  const Button({required this.buttonText, required this.function, super.key});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isPressed = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => isLoading = true);
        await widget.function();
        setState(() => isLoading = false);
      },

      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),

      child: AnimatedScale(
        scale: isPressed ? 0.8 : 1.0,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
        child: SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            color: Colors.white,
            elevation: 10,
            shadowColor: Colors.white.withValues(alpha: 0.5),
            child: Center(
              child: isLoading
                ? const CircularProgressIndicator(color: Color.fromARGB(255, 254, 160, 109))
                : Text(
                    widget.buttonText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 254, 160, 109),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
