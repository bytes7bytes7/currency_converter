import 'package:currency_converter/bloc/exchange_bloc.dart';
import 'package:flutter/material.dart';

import '../widgets/search_bar.dart';
import '../widgets/loading_circle.dart';
import '../models/currency.dart';
import '../bloc/currency_bloc.dart';

class CurrencyScreen extends StatelessWidget {
  CurrencyScreen({
    Key? key,
    required this.currencyNotifier,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier;
  final ValueNotifier<Offset?> tapPosition = ValueNotifier(const Offset(0, 0));

  void _showPopupMenu(BuildContext context, Currency currency) async {
    await showMenu(
      context: context,
      color: Theme.of(context).focusColor.withOpacity(0.75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      position: RelativeRect.fromLTRB(
          tapPosition.value!.dx, tapPosition.value!.dy, 40.0, 80.0),
      items: [
        PopupMenuItem(
          value: 1,
          enabled: false,
          height: 30,
          child: Text(
            'Страна: ${currency.country}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        PopupMenuItem(
          value: 2,
          enabled: false,
          height: 30,
          child: Text(
            'Курс \$: ${currency.rate.toString().replaceAll('.', ',')}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        PopupMenuItem(
          value: 3,
          enabled: false,
          height: 30,
          child: Text(
            'День: ${currency.dayDelta}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        PopupMenuItem(
          value: 4,
          enabled: false,
          height: 30,
          child: Text(
            'Неделя: ${currency.weekDelta}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        PopupMenuItem(
          value: 5,
          enabled: false,
          height: 30,
          child: Text(
            'Месяц: ${currency.monthDelta}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
        PopupMenuItem(
          value: 6,
          enabled: false,
          height: 30,
          child: Text(
            'Год: ${currency.yearDelta}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const _AppBar(),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: StreamBuilder(
                  stream: CurrencyBloc.currency,
                  initialData: CurrencyInitState(),
                  builder: (context, snapshot) {
                    if (snapshot.data is CurrencyInitState) {
                      CurrencyBloc.loadAllCurrencies();
                      return const SizedBox.shrink();
                    } else if (snapshot.data is CurrencyLoadingState) {
                      return const SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: LoadingCircle(),
                      );
                    } else if (snapshot.data is CurrencyDataState) {
                      CurrencyDataState state =
                          snapshot.data as CurrencyDataState;
                      return Column(
                        children: [
                          // TODO: complete
                          const SearchBar(),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.currencies.length,
                              itemBuilder: (context, index) {
                                String flag =
                                    state.currencies[index].iso != null
                                        ? state.currencies[index].getFlag()
                                        : '';
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: RawMaterialButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      currencyNotifier.value =
                                          state.currencies[index];
                                      ExchangeBloc.updateCalculation();
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      height: 60.0,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: (flag.isNotEmpty &&
                                                    flag.contains('.png'))
                                                ? Image.asset('assets/png/crypto/$flag')
                                                : RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: state
                                                                      .currencies[
                                                                          index]
                                                                      .iso !=
                                                                  null
                                                              ? state
                                                                  .currencies[
                                                                      index]
                                                                  .getFlag()
                                                              : '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 35,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            state.currencies[index].iso ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              state.currencies[index].name ??
                                                  '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              Icons.info_outline,
                                              color:
                                                  Theme.of(context).focusColor,
                                              size: 28.0,
                                            ),
                                            onTapDown:
                                                (TapDownDetails details) {
                                              tapPosition.value =
                                                  details.globalPosition;
                                            },
                                            onTapUp: (TapUpDetails details) {
                                              _showPopupMenu(
                                                context,
                                                state.currencies[index],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Container(
                                  height: 1.0,
                                  width: double.infinity,
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.25),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
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
          Icons.arrow_back_ios_outlined,
          size: 28.0,
          color: Theme.of(context).focusColor,
        ),
        splashColor: Theme.of(context).disabledColor.withOpacity(0.25),
        splashRadius: 22.0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        'Валюта',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
