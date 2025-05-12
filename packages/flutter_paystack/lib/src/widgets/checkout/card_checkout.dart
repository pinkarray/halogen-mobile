import 'package:flutter/material.dart';
import 'package:flutter_paystack/src/api/service/contracts/cards_service_contract.dart';
import 'package:flutter_paystack/src/common/exceptions.dart';
import 'package:flutter_paystack/src/common/my_strings.dart';
import 'package:flutter_paystack/src/common/paystack.dart';
import 'package:flutter_paystack/src/common/utils.dart';
import 'package:flutter_paystack/src/models/card.dart';
import 'package:flutter_paystack/src/models/charge.dart';
import 'package:flutter_paystack/src/transaction/card_transaction_manager.dart';
import 'package:flutter_paystack/src/widgets/checkout/base_checkout.dart';
import 'package:flutter_paystack/src/widgets/checkout/checkout_widget.dart';
import 'package:flutter_paystack/src/widgets/input/card_input.dart';

class CardCheckout extends StatefulWidget {
  final Charge charge;
  final OnResponse onResponse;
  final ValueChanged<bool> onProcessingChange;
  final ValueChanged<PaymentCard?> onCardChange;
  final bool hideAmount;
  final CardServiceContract service;
  final String publicKey;

  const CardCheckout({
    Key? key,
    required this.charge,
    required this.onResponse,
    required this.onProcessingChange,
    required this.onCardChange,
    required this.service,
    required this.publicKey,
    this.hideAmount = false,
  }) : super(key: key);

  @override
  CardCheckoutState createState() => CardCheckoutState();
}

class CardCheckoutState extends BaseCheckoutMethodState<CardCheckout> {
  late Charge _charge;

  CardCheckoutState() : super(CheckoutMethod.card);

  @override
  void initState() {
    super.initState();
    _charge = widget.charge;
    // You now already have `onResponse` from BaseCheckoutMethodState.initState
  }

  @override
  Widget buildAnimatedChild() {
    var amountText =
        _charge.amount.isNegative ? '' : Utils.formatAmount(_charge.amount);

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Text(
            Strings.cardInputInstruction,
            key: Key("InstructionKey"),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20.0,
          ),
          CardInput(
            key: Key("CardInput"),
            buttonText: widget.hideAmount ? "Continue" : 'Pay $amountText',
            card: _charge.card,
            onValidated: _onCardValidated,
          ),
        ],
      ),
    );
  }

  void _onCardValidated(PaymentCard? card) {
    if (card == null) return;
    _charge.card = card;
    widget.onCardChange(_charge.card);
    widget.onProcessingChange(true);

    if ((_charge.accessCode != null && _charge.accessCode!.isNotEmpty) ||
        _charge.reference != null && _charge.reference!.isNotEmpty) {
      _chargeCard(_charge);
    } else {
      // This should never happen. Validation has already been done in [PaystackPlugin .checkout]
      throw ChargeException(Strings.noAccessCodeReference);
    }
  }

  void _chargeCard(Charge charge) async {
    final response = await CardTransactionManager(
      charge: charge,
      context: context,
      service: widget.service,
      publicKey: widget.publicKey,
    ).chargeCard();
    onResponse(response);
  }
}
