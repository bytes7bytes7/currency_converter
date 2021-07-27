import 'package:flutter/material.dart';

import '../models/exchange.dart';
import '../models/currency.dart';
import '../screens/currency_screen.dart';
import '../database/database_helper.dart';
import '../global_parameters.dart';

class CurrencyInputField extends StatelessWidget {
  const CurrencyInputField({
    Key? key,
    this.enabled = true,
    required this.currencyNotifier,
    required this.textEditingController,
    required this.currencyScrollOffset,
    required this.addToHistory,
  }) : super(key: key);

  final bool enabled;
  final ValueNotifier<Currency> currencyNotifier;
  final TextEditingController textEditingController;
  final ValueNotifier<double> currencyScrollOffset;
  final Function addToHistory;

  void loadCurrencyData() async {
    currencyNotifier.value =
        await DatabaseHelper.db.getCurrency(currencyNotifier.value.iso!);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      readOnly: true,
      showCursor: enabled,
      autofocus: true,
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.end,
      scrollPhysics: const BouncingScrollPhysics(),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).disabledColor.withOpacity(0.25),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).disabledColor.withOpacity(0.25),
          ),
        ),
        prefixIcon: RawMaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CurrencyScreen(
                  currencyNotifier: currencyNotifier,
                  currencyScrollOffset: currencyScrollOffset,
                ),
              ),
            );
          },
          splashColor: Theme.of(context).disabledColor,
          child: SizedBox(
            width: 120,
            height: 40,
            child: ValueListenableBuilder(
              valueListenable: currencyNotifier,
              builder: (context, _, __) {
                if (textEditingController.text.isNotEmpty && enabled) {
                  if (GlobalParameters.lastExchange.value != GlobalParameters.exchangeNotifier.value) {
                    addToHistory();
                    GlobalParameters.lastExchange.value = Exchange.from(GlobalParameters.exchangeNotifier.value);
                  }
                }
                if (currencyNotifier.value.rate == null) {
                  loadCurrencyData();
                }
                String flag = currencyNotifier.value.iso != null
                    ? currencyNotifier.value.getFlag()
                    : '';
                return Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: (flag.isNotEmpty && flag.contains('.png'))
                          ? Image.asset('assets/png/additional_flags/$flag')
                          : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: currencyNotifier.value.iso != null
                                        ? currencyNotifier.value.getFlag()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      currencyNotifier.value.iso ?? '',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
