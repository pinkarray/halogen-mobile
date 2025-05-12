import 'package:flutter/material.dart';
import 'package:flutter_paystack/src/common/paystack.dart';
import 'package:flutter_paystack/src/widgets/animated_widget.dart';
import 'package:flutter_paystack/src/widgets/checkout/checkout_widget.dart';

abstract class BaseCheckoutMethodState<T extends StatefulWidget>
    extends BaseAnimatedState<T> {
  late final OnResponse onResponse;
  final CheckoutMethod _method;

  BaseCheckoutMethodState(this._method);

  @override
  void initState() {
    super.initState();
    onResponse = (widget as dynamic).onResponse;
  }

  CheckoutMethod get method => _method;
}

