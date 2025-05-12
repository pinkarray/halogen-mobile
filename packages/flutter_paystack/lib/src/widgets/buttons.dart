import 'package:flutter/material.dart';
import 'package:flutter_paystack/src/widgets/common/extensions.dart';

class WhiteButton extends _BaseButton {
  final bool flat;
  final bool bold;
  final IconData? _iconData;

  @override
  IconData? get iconData => _iconData;

  WhiteButton({
    required VoidCallback? onPressed,
    String? text,
    Widget? child,
    this.flat = false,
    this.bold = true,
    IconData? iconData,
  })  : _iconData = iconData,
        super(
          onPressed: onPressed,
          showProgress: false,
          text: text,
          child: child,
          iconData: iconData,
          textStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.black87.withAlpha((0.8 * 255).round()),
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
          color: Colors.white,
          borderSide: flat
              ? BorderSide.none
              : const BorderSide(color: Colors.grey, width: 0.5),
        );
}

class AccentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool showProgress;

  const AccentButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.showProgress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseButton(
      onPressed: onPressed,
      showProgress: showProgress,
      color: context.colorScheme().secondary,
      borderSide: BorderSide.none,
      textStyle: const TextStyle(
        fontSize: 14.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      text: text,
    );
  }
}

class _BaseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool showProgress;
  final TextStyle textStyle;
  final Color color;
  final BorderSide borderSide;
  final IconData? iconData;
  final Widget? child;

  const _BaseButton({
    required this.onPressed,
    required this.showProgress,
    required this.text,
    required this.textStyle,
    required this.color,
    required this.borderSide,
    this.iconData,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(5.0));
    Widget? textWidget;

    if (text != null) {
      textWidget = Text(
        text!,
        textAlign: TextAlign.center,
        style: textStyle,
      );
    }

    return Container(
      width: double.infinity,
      height: 50.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
      ),
      child: TextButton(
        onPressed: showProgress ? null : onPressed,
        child: showProgress
            ? const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              )
            : iconData == null
                ? (child ?? textWidget ?? const SizedBox.shrink())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        iconData,
                        color: textStyle.color!.withAlpha((0.5 * 255).round()),
                      ),
                      const SizedBox(width: 2.0),
                      textWidget ?? const SizedBox.shrink(),
                    ],
                  ),
      ),
    );
  }
}