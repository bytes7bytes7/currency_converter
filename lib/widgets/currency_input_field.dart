import 'package:flutter/material.dart';

import '../models/currency.dart';

class CurrencyInputField extends StatelessWidget {
  const CurrencyInputField({
    Key? key,
    required this.currencyNotifier,
    required this.textEditingController,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      enabled: false,
      style: Theme.of(context).textTheme.bodyText1,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        prefixIcon: SizedBox(
          width: 100,
          child: Material(
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: SizedBox(
                      height: 30,
                      width: 47,
                      child: Image.asset(
                        'icons/flags/png/ru.png',
                        package: 'country_icons',
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
      ),
    );
  }
}