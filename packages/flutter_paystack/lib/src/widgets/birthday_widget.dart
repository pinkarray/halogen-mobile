import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'base_widget.dart';
import 'package:flutter_paystack/src/widgets/buttons.dart';
import 'package:flutter_paystack/src/widgets/common/extensions.dart';
import 'package:flutter_paystack/src/widgets/custom_dialog.dart';
import 'package:intl/intl.dart';

const double _kPickerSheetHeight = 216.0;

class BirthdayWidget extends StatefulWidget {
  final String message;

  const BirthdayWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  BirthdayWidgetState createState() => BirthdayWidgetState();
}

class BirthdayWidgetState extends BaseState<BirthdayWidget> {
  var heightBox = const SizedBox(height: 20.0);
  DateTime? _pickedDate;

  @override
  void initState() {
    super.initState();
    confirmationMessage = 'Do you want to cancel birthday input?';
  }

  @override
  Widget buildChild(BuildContext context) {
    return CustomAlertDialog(
        content: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/dob.png',
                width: 30.0, package: 'flutter_paystack'),
            heightBox,
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: context.textTheme().titleLarge?.color,
                fontSize: 15.0,
              ),
            ),
            heightBox,
            _pickedDate == null
                ? WhiteButton(
                    onPressed: _selectBirthday, text: 'Pick birthday')
                : WhiteButton(
                    onPressed: _selectBirthday,
                    flat: true,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(flex: 4, child: dateItem(_getMonth())),
                        Flexible(flex: 2, child: dateItem(_getDay())),
                        Flexible(flex: 3, child: dateItem(_getYear()))
                      ],
                    ),
                  ),
            SizedBox(
              height: _pickedDate == null ? 5.0 : 20.0,
            ),
            _pickedDate == null
                ? Container()
                : AccentButton(onPressed: _onAuthorize, text: 'Authorize'),
            Container(
              padding:
                  EdgeInsets.only(top: _pickedDate == null ? 15.0 : 20.0),
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
    ));
  }

  void _selectBirthday() async {
    updateDate(date) {
      setState(() => _pickedDate = date);
    }

    var now = DateTime.now();
    var minimumYear = 1900;
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: _kPickerSheetHeight,
                padding: const EdgeInsets.only(top: 6.0),
                color: CupertinoColors.white,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 22.0,
                  ),
                  child: GestureDetector(
                    // Blocks taps from propagating to the modal sheet and popping.
                    onTap: () {},
                    child: SafeArea(
                      top: false,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: now,
                        maximumDate: now,
                        minimumYear: minimumYear,
                        maximumYear: now.year,
                        onDateTimeChanged: updateDate,
                      ),
                    ),
                  ),
                ),
              ));
    } else {
      DateTime? result = await showDatePicker(
          context: context,
          selectableDayPredicate: (DateTime val) =>
              val.year > now.year && val.month > now.month && val.day > now.day
                  ? false
                  : true,
          initialDate: now,
          firstDate: DateTime(minimumYear),
          lastDate: now);

      updateDate(result);
    }
  }

  Widget dateItem(String text) {
    const side = BorderSide(color: Colors.grey, width: 0.5);
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          border:
              Border(top: side, right: side, bottom: side, left: side)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getMonth() {
    return DateFormat('MMMM').format(_pickedDate!);
  }

  String _getDay() {
    return DateFormat('dd').format(_pickedDate!);
  }

  String _getYear() {
    return DateFormat('yyyy').format(_pickedDate!);
  }

  void _onAuthorize() {
    String date = DateFormat('yyyy-MM-dd').format(_pickedDate!);
    Navigator.of(context).pop(date);
  }
}
