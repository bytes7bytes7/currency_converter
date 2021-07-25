import 'package:currency_converter/screens/currency_screen.dart';
import 'package:currency_converter/services/next_page_route.dart';
import 'package:flutter/material.dart';

import '../models/currency.dart';

class CurrencyInputField extends StatelessWidget {
  const CurrencyInputField({
    Key? key,
    this.enabled = true,
    required this.currencyNotifier,
    required this.textEditingController,
    required this.currencyScrollOffset,
  }) : super(key: key);

  final bool enabled;
  final ValueNotifier<Currency> currencyNotifier;
  final TextEditingController textEditingController;
  final ValueNotifier<double> currencyScrollOffset;

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
              NextPageRoute(
                nextPage: CurrencyScreen(
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
