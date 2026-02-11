import 'package:flutter/material.dart';

class SelectQuantity extends StatefulWidget {
  final int stockQuantity;
  final ValueChanged<int> onChanged;
  const SelectQuantity({required this.stockQuantity, required this.onChanged, super.key});

  @override
  State<SelectQuantity> createState() => _SelectQuantityState();
}

class _SelectQuantityState extends State<SelectQuantity> {
  int quantity = 0;
  bool isInvalid = false;

  void _update(int newValue) {
    setState(() => quantity = newValue);
    widget.onChanged(quantity);
  }

  @override
  void initState() {
    super.initState();

    setState(() => quantity = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60,
          width: 60,
          child: Card(
            child: IconButton(
              onPressed: quantity > 0 
              ? () => _update(quantity-1) 
              : _invalidValue,
              icon: Icon(
                Icons.arrow_back, 
                color: isInvalid
                  ? Colors.red 
                  : const Color.fromARGB(255, 254, 160, 109),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          width: 60,
          child: Card(
            child: Center(
              child: Text(
                quantity.toString(), 
                style: TextStyle(
                  color: isInvalid
                    ? Colors.red 
                    : const Color.fromARGB(255, 254, 160, 109),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          width: 60,
          child: Card(
            child: IconButton(
              onPressed: quantity >= widget.stockQuantity 
              ? _invalidValue
              : () => _update(quantity+1),
              icon: Icon(
                Icons.arrow_forward, 
                color: isInvalid
                  ? Colors.red 
                  : const Color.fromARGB(255, 254, 160, 109),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _invalidValue() async {
    setState(() => isInvalid = !isInvalid);

    await Future.delayed(Duration(seconds: 1));

    setState(() => isInvalid = !isInvalid);
  }
}