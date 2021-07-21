import 'package:flutter/material.dart';

import '../widgets/number_panel.dart';
import '../widgets/currency_input_field.dart';
import '../models/currency.dart';
import '../services/amount_text_input_formatter.dart';

class ConvertScreen extends StatelessWidget {
  ConvertScreen({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier1 = ValueNotifier(
    Currency(
      iso: 'USD',
      name: 'Доллар США',
      country: 'США',
      rate: 1,
    ),
  );
  final ValueNotifier<Currency> currencyNotifier2 = ValueNotifier(
    Currency(
      iso: 'RUB',
      name: 'Российский рубль',
      country: 'Россия',
      rate: 74.38,
    ),
  );
  final TextEditingController currencyController1 = TextEditingController();
  final TextEditingController currencyController2 = TextEditingController();
  final ValueNotifier<TextEditingController> textNotifier =
      ValueNotifier(TextEditingController());
  final AmountTextInputFormatter _formatter = AmountTextInputFormatter();

  void changeValue(String action) {
    if (action == 'erase') {
      String oldText = textNotifier.value.text;
      if (oldText.isNotEmpty) {
        String newText = oldText.substring(0, oldText.length - 1);
        TextEditingValue value = _formatter.formatEditUpdate(
          TextEditingValue(
              text: oldText, selection: textNotifier.value.selection),
          TextEditingValue(text: newText),
        );
        textNotifier.value.text = value.text;
      }
    } else {
      print(textNotifier.value.selection.extentOffset);
      String newText = textNotifier.value.text;
      final tmp = newText.split('');
      tmp.insert(
          textNotifier.value.selection.end != -1
              ? textNotifier.value.selection.end
              : textNotifier.value.text.length,
          action);
      newText = tmp.join('');
      TextEditingValue value = _formatter.formatEditUpdate(
        TextEditingValue(
          text: textNotifier.value.text,
          selection: textNotifier.value.selection,
        ),
        TextEditingValue(
          text: newText,
          selection: textNotifier.value.selection.copyWith(
            baseOffset: textNotifier.value.selection.extentOffset + 1,
            extentOffset: textNotifier.value.selection.extentOffset + 1,
          ),
        ),
      );
      textNotifier.value.text = value.text;
    }
    if (textNotifier.value == currencyController1) {
      String curr1Text = currencyController1.text;
      if (currencyController1.text.endsWith(',')) {
        curr1Text = currencyController1.text
            .substring(0, currencyController1.text.length - 1);
      }
      curr1Text = curr1Text.replaceAll(',', '').replaceAll(' ', '');
      if(curr1Text.isEmpty){
        curr1Text = '0';
      }
      currencyController2.text = (double.parse(curr1Text) *
              currencyNotifier2.value.rate! /
              currencyNotifier1.value.rate!)
          .toString();
      if (currencyController2.text.isEmpty) {
        currencyController2.text = '0';
      }
    } else {
      String curr2Text = currencyController2.text;
      if (currencyController2.text.endsWith(',')) {
        curr2Text = currencyController2.text
            .substring(0, currencyController2.text.length - 1);
      }
      curr2Text = curr2Text.replaceAll(',', '').replaceAll(' ', '');
      if(curr2Text.isEmpty){
        curr2Text = '0';
      }
      currencyController1.text = (double.parse(curr2Text) *
              currencyNotifier1.value.rate! /
              currencyNotifier2.value.rate!)
          .toString();
      if (currencyController1.text.isEmpty) {
        currencyController1.text = '0';
      }
    }
  }

  void clearField() {
    textNotifier.value.text = '';
  }

  @override
  Widget build(BuildContext context) {
    textNotifier.value = currencyController1;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const _AppBar(),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language_outlined,
                      color: Theme.of(context).disabledColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      'Обновлено 12:51',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                CurrencyInputField(
                  currencyNotifier: currencyNotifier1,
                  textEditingController: currencyController1,
                  textNotifier: textNotifier,
                ),
                IconButton(
                  icon: Icon(
                    Icons.swap_vert_outlined,
                    color: Theme.of(context).focusColor,
                    size: 28.0,
                  ),
                  splashColor: Theme.of(context).disabledColor,
                  splashRadius: 22.0,
                  onPressed: () {
                    final String text = currencyController1.text;
                    currencyController1.text = currencyController2.text;
                    currencyController2.text = text;
                    final currency = currencyNotifier1.value;
                    currencyNotifier1.value = currencyNotifier2.value;
                    currencyNotifier2.value = currency;
                  },
                ),
                CurrencyInputField(
                  currencyNotifier: currencyNotifier2,
                  textEditingController: currencyController2,
                  textNotifier: textNotifier,
                ),
                const Spacer(
                  flex: 2,
                ),
                NumberPanel(
                  textNotifier: textNotifier,
                  onTap: changeValue,
                  onLongPress: clearField,
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.refresh_outlined,
          size: 28.0,
          color: Theme.of(context).focusColor,
        ),
        splashColor: Theme.of(context).disabledColor,
        splashRadius: 22.0,
        onPressed: () {},
      ),
      centerTitle: true,
      title: Text(
        'Конвертер',
        style: Theme.of(context).textTheme.headline1,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.history_outlined,
            size: 28.0,
            color: Theme.of(context).focusColor,
          ),
          splashColor: Theme.of(context).disabledColor,
          splashRadius: 22.0,
          onPressed: () {},
        ),
      ],
    );
  }
}
