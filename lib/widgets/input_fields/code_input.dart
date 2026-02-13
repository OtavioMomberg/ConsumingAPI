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
                height: getSize(),
                width: getSize(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Text(code?[index] ?? "", style: const TextStyle(color: Colors.white)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  double getSize() {
    // 0.9 => Tamanho da largura do widget Pai
    // 60 => Soma dos Padding left e Right do Widget Pai e da Tela
    // 6 => Quantidade de quadrados a criar
    final size = (MediaQuery.of(context).size.width * 0.9 - 70) / 6;
    return size;
  }
}