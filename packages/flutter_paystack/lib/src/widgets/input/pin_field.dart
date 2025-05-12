import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/src/widgets/common/extensions.dart';

class PinField extends StatefulWidget {
  final ValueChanged<String>? onSaved;
  final int pinLength;

  const PinField({
    Key? key,
    this.onSaved,
    this.pinLength = 4,
  }) : super(key: key);

  @override
  State createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
          letterSpacing: 15.0,
        ),
        autofocus: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.pinLength),
        ],
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          hintText: 'ENTER PIN',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
            letterSpacing: 0,
          ),
          contentPadding: const EdgeInsets.all(10.0),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: context.colorScheme().secondary, width: 1.0)),
        ),
        onChanged: (String value) {
          if (value.length == widget.pinLength) {
            widget.onSaved!(value);
          }
        },
      ),
    );
  }
}
