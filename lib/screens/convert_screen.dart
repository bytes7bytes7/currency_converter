import 'package:flutter/material.dart';

import '../widgets/number_panel.dart';
import '../widgets/currency_input_field.dart';
import '../models/currency.dart';
import '../services/amount_text_input_formatter.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

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
  final TextEditingController currencyController2 =
      TextEditingController(text: '0');
  final ValueNotifier<TextEditingController> textNotifier =
      ValueNotifier(TextEditingController());
  final AmountTextInputFormatter _formatter = AmountTextInputFormatter();

  void changeValue(String action) {
    if (action == 'erase') {
      if (textNotifier.value.selection.end != 0 &&
          textNotifier.value.text.isNotEmpty) {
        final oldValue = textNotifier.value.value;
        final tmp = textNotifier.value.text.split('');
        if (textNotifier.value.selection.end == -1) {
          tmp.removeAt(textNotifier.value.text.length - 1);
        } else {
          tmp.removeAt(textNotifier.value.selection.end - 1);
        }
        int offset;
        if (textNotifier.value.selection.end == -1) {
          offset = -1;
        } else {
          offset = textNotifier.value.selection.end - 1;
        }
        TextEditingValue newValue = TextEditingValue(
          text: tmp.join(''),
          selection: TextSelection(
            baseOffset: offset,
            extentOffset: offset,
          ),
        );
        textNotifier.value.value =
            _formatter.formatEditUpdate(oldValue, newValue);
      }
    } else {
      TextEditingValue oldValue = textNotifier.value.value;
      final tmp = textNotifier.value.text.split('');
      if (textNotifier.value.selection.end == -1) {
        tmp.insert(textNotifier.value.text.length, action);
      } else {
        tmp.insert(textNotifier.value.selection.end, action);
      }
      int offset;
      if (textNotifier.value.selection.end == -1) {
        offset = -1;
      } else {
        offset = textNotifier.value.selection.end + 1;
      }
      TextEditingValue newValue = TextEditingValue(
        text: tmp.join(''),
        selection: TextSelection(
          baseOffset: offset,
          extentOffset: offset,
        ),
      );
      textNotifier.value.value =
          _formatter.formatEditUpdate(oldValue, newValue);
    }
    if (textNotifier.value == currencyController1) {
      final TextEditingValue oldValue = TextEditingValue(
        text: currencyController2.text,
      );
      final String currText1 =
          currencyController1.text.replaceAll(',', '.').replaceAll(' ', '');
      if (currText1.isNotEmpty) {
        double v = (double.parse(currText1) *
            currencyNotifier2.value.rate! /
            currencyNotifier1.value.rate!);
        final TextEditingValue newValue = TextEditingValue(
          text: v.toStringAsFixed(2),
        );
        currencyController2.text =
            _formatter.formatEditUpdate(oldValue, newValue).text;
      } else {
        currencyController2.text = '0';
      }
    } else {
      final TextEditingValue oldValue = TextEditingValue(
        text: currencyController1.text,
      );
      final String currText2 =
          currencyController2.text.replaceAll(',', '.').replaceAll(' ', '');
      if (currText2.isNotEmpty) {
        double v = double.parse(currText2) *
            currencyNotifier1.value.rate! /
            currencyNotifier2.value.rate!;
        final TextEditingValue newValue = TextEditingValue(
          text: v.toStringAsFixed(2),
        );
        currencyController1.text =
            _formatter.formatEditUpdate(oldValue, newValue).text;
      } else {
        currencyController1.text = '0';
      }
    }
  }

  void clearField() {
    currencyController1.text = '0';
    currencyController2.text = '0';
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
                RawMaterialButton(
                  splashColor:
                      Theme.of(context).disabledColor.withOpacity(0.25),
                  child: Row(
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
                  onPressed: () {},
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
                  splashColor:
                      Theme.of(context).disabledColor.withOpacity(0.25),
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
          Icons.settings_outlined,
          size: 28.0,
          color: Theme.of(context).focusColor,
        ),
        splashColor: Theme.of(context).disabledColor.withOpacity(0.25),
        splashRadius: 22.0,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
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
          splashColor: Theme.of(context).disabledColor.withOpacity(0.25),
          splashRadius: 22.0,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
