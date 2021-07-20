import 'package:flutter/material.dart';

import '../widgets/number_panel.dart';
import '../widgets/currency_input_field.dart';
import '../models/currency.dart';

class ConvertScreen extends StatelessWidget {
  ConvertScreen({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier1 = ValueNotifier(Currency());
  final ValueNotifier<Currency> currencyNotifier2 = ValueNotifier(Currency());
  final TextEditingController currencyController1 = TextEditingController();
  final TextEditingController currencyController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.swap_vert_outlined,
                      color: Theme.of(context).focusColor,
                      size: 28.0,
                    ),
                    splashColor: Theme.of(context).disabledColor,
                    splashRadius: 22.0,
                    onPressed: () {},
                  ),
                  CurrencyInputField(
                    currencyNotifier: currencyNotifier2,
                    textEditingController: currencyController2,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  const NumberPanel(),
                  const Spacer(
                    flex: 2,
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
