import 'package:flutter/material.dart';
import 'package:flutter_paystack/src/models/card.dart';
import 'package:flutter_paystack/src/widgets/base_widget.dart';
import 'package:flutter_paystack/src/widgets/buttons.dart';
import 'package:flutter_paystack/src/widgets/custom_dialog.dart';
import 'package:flutter_paystack/src/widgets/input/card_input.dart';

class CardInputWidget extends StatefulWidget {
  final PaymentCard? card;

  const CardInputWidget({
    Key? key,
    this.card,
  }) : super(key: key);

  @override
  CardInputWidgetState createState() => CardInputWidgetState();
}


class CardInputWidgetState extends BaseState<CardInputWidget> {
  @override
  void initState() {
    super.initState();
    confirmationMessage = 'Do you want to cancel card input?';
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Text(
                'Please, provide valid card details.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 35.0,
              ),
              CardInput(
                buttonText: 'Continue',
                card: widget.card,
                onValidated: _onCardValidated,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0),
                child: WhiteButton(
                  onPressed: onCancelPress,
                  text: 'Cancel',
                  flat: true,
                  bold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardValidated(PaymentCard? card) {
    Navigator.pop(context, card);
  }
}
