import 'package:flutter/material.dart';

class CodeInput extends StatefulWidget {
  final Future<String> Function() getCode;
  const CodeInput({required this.getCode, super.key});

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  String? code;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        code = await widget.getCode();
        if (code != null) {
          code = code!.replaceFirst(" ", "");
        }
        setState(() {});
      },
      child: SizedBox(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ...List.generate(6, (index) {
              return Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Center(child: Text(code?[index] ?? "", style: const TextStyle(color: Colors.white))),
              );
            })
          ],
        ),
      ),
    );
  }
}