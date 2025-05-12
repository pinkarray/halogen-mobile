import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/src/models/checkout_response.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool isProcessing = false;
  String confirmationMessage = 'Do you want to cancel payment?';
  bool alwaysPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldExit = await _onWillPop();
          if (shouldExit && mounted) {
            Navigator.of(context).pop(getPopReturnValue());
          }
        }
      },
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context);

  Future<bool> _onWillPop() async {
    if (isProcessing) return false;

    final returnValue = getPopReturnValue();

    if (alwaysPop ||
        (returnValue is CheckoutResponse && returnValue.status == true)) {
      if (mounted) Navigator.of(context).pop(returnValue);
      return false;
    }

    final Widget text = Text(
      confirmationMessage,
      textAlign: TextAlign.center,
    );

    final dialog = Platform.isIOS
        ? CupertinoAlertDialog(
            content: text,
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Yes'),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
            ],
          )
        : AlertDialog(
            content: text,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('NO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('YES'),
              ),
            ],
          );

    final bool exit = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => dialog,
        ) ??
        false;

    if (exit && mounted) {
      Navigator.of(context).pop(returnValue);
    }

    return false;
  }

  void onCancelPress() async {
    final shouldClose = await _onWillPop();
    if (shouldClose && mounted) {
      Navigator.of(context).pop(getPopReturnValue());
    }
  }

  dynamic getPopReturnValue() {
    return null;
  }
}
