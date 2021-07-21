import 'package:flutter/material.dart';

import '../models/currency.dart';

class CurrencyInputField extends StatelessWidget {
  const CurrencyInputField({
    Key? key,
    required this.currencyNotifier,
    required this.textEditingController,
    required this.textNotifier,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier;
  final TextEditingController textEditingController;
  final ValueNotifier<TextEditingController> textNotifier;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      readOnly: true,
      showCursor: true,
      autofocus: true,
      onTap: () {
        textNotifier.value = textEditingController;
      },
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        prefixIcon: RawMaterialButton(
          onPressed: () {},
          child: SizedBox(
            width: 100,
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: Currency(letters: 'ARS').getFlag(),
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
                  'RUB',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
