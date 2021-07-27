import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../bloc/currency_bloc.dart';
import '../bloc/exchange_bloc.dart';
import '../widgets/loading_circle.dart';
import '../models/currency.dart';

List<Currency> search(Map<String, dynamic> map) {
  if (map['value'].isEmpty) {
    return map['allCurrencies'];
  }
  List<Currency> currencies = <Currency>[];
  String formattedValue = map['value'].toLowerCase();
  for (int i = 0; i < map['allCurrencies'].length; i++) {
    if (map['allCurrencies'][i].iso!.toLowerCase().contains(formattedValue) ||
        map['allCurrencies'][i].name!.toLowerCase().contains(formattedValue)) {
      currencies.add(Currency.from(map['allCurrencies'][i]));
    }
  }
  return currencies;
}

class CurrencyScreen extends StatelessWidget {
  CurrencyScreen({
    Key? key,
    required this.currencyNotifier,
    required this.currencyScrollOffset,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier;
  final ValueNotifier<double> currencyScrollOffset;
  final ValueNotifier<List<Currency>> searchCurrencies =
      ValueNotifier(<Currency>[]);
  final ValueNotifier<Future<void>> computeFuture =
      ValueNotifier(Future.value());
  final List<Currency> allCurrencies = <Currency>[];

  VoidCallback? createComputeCallback(
      BuildContext context, AsyncSnapshot snapshot, String value) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        computeFuture.value = computeData(value).then((val) {
          searchCurrencies.value = val;
        });
      };
    }
  }

  Future<List<Currency>> computeData(String value) async {
    return await compute(
      search,
      {'value': value, 'allCurrencies': allCurrencies},
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const _AppBar(),
        body: SafeArea(
          child: Center(
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
                  CurrencyDataState state = snapshot.data as CurrencyDataState;
                  allCurrencies.clear();
                  allCurrencies.addAll(state.currencies);
                  searchCurrencies.value = List.from(allCurrencies);
                  // return GestureDetector(
                  //   onTap: () {
                  //     showSearch(
                  //       context: context,
                  //       delegate: SearchBar(),
                  //     );
                  //   },
                  //   child: Container(
                  //     color: Colors.green,
                  //     height: 10,
                  //     width: 10,
                  //   ),
                  // );
                  return FutureBuilder(
                    future: computeFuture.value,
                    builder: (futureContext, futureSnapshot) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 26.0,
                              left: 30.0,
                              right: 30.0,
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            width: double.infinity,
                            height: 42.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Icon(
                                    Icons.search_outlined,
                                    color: Theme.of(context).disabledColor,
                                    size: 24.0,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: searchController,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    onChanged: (value) {
                                      var callback = createComputeCallback(
                                          futureContext, futureSnapshot, value);
                                      if (callback != null) {
                                        callback();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Поиск',
                                      hintStyle:
                                          Theme.of(context).textTheme.subtitle1,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (futureSnapshot.connectionState ==
                                  ConnectionState.waiting)
                              ? const SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: LoadingCircle(),
                                )
                              : _CurrencyList(
                                  searchCurrencies: searchCurrencies,
                                  currencyScrollOffset: currencyScrollOffset,
                                  allCurrencies: allCurrencies,
                                  currencyNotifier: currencyNotifier,
                                ),
                        ],
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
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
      leading: const SizedBox.shrink(),
      actions: [
        IconButton(
          icon: Icon(
            Icons.close_outlined,
            size: 28.0,
            color: Theme.of(context).focusColor,
          ),
          splashColor: Theme.of(context).disabledColor.withOpacity(0.25),
          splashRadius: 22.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      centerTitle: true,
      title: Text(
        'Валюта',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class _CurrencyList extends StatelessWidget {
  _CurrencyList({
    Key? key,
    required this.searchCurrencies,
    required this.currencyScrollOffset,
    required this.allCurrencies,
    required this.currencyNotifier,
  }) : super(key: key);

  final ValueNotifier<List<Currency>> searchCurrencies;
  final ValueNotifier<double> currencyScrollOffset;
  final List<Currency> allCurrencies;
  final ValueNotifier<Currency> currencyNotifier;

  final ValueNotifier<Offset?> _tapPosition = ValueNotifier(const Offset(0, 0));

  void _showPopupMenu(BuildContext context, Currency currency) async {
    await showMenu(
      context: context,
      color: Theme.of(context).focusColor.withOpacity(0.75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      position: RelativeRect.fromLTRB(
          _tapPosition.value!.dx, _tapPosition.value!.dy, 40.0, 80.0),
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

  void onPressed(BuildContext context, int index) {
    int i = allCurrencies
        .indexWhere((e) => e.iso == searchCurrencies.value[index].iso);
    currencyScrollOffset.value = i * 80.0 + i - 40.0;
    currencyNotifier.value = searchCurrencies.value[index];
    ExchangeBloc.updateCalculation();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: searchCurrencies,
      builder: (context, _, __) {
        return Expanded(
          child: Scrollbar(
            controller: ScrollController(
                initialScrollOffset: currencyScrollOffset.value),
            thickness: 8,
            radius: const Radius.circular(5),
            child: ListView.separated(
              controller: ScrollController(
                  initialScrollOffset: currencyScrollOffset.value),
              physics: const BouncingScrollPhysics(),
              itemCount: searchCurrencies.value.length,
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30.0),
                  height: 1.0,
                  width: double.infinity,
                  color: Theme.of(context).disabledColor.withOpacity(0.25),
                );
              },
              itemBuilder: (context, index) {
                String flag = searchCurrencies.value[index].iso != null
                    ? searchCurrencies.value[index].getFlag()
                    : '';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: RawMaterialButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      onPressed(context, index);
                    },
                    child: SizedBox(
                      height: 60.0,
                      width: double.infinity,
                      child: Row(
                        children: [
                          const SizedBox(width: 30.0),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: (flag.isNotEmpty && flag.contains('.png'))
                                ? Image.asset(
                                    'assets/png/additional_flags/$flag')
                                : RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: flag,
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
                            searchCurrencies.value[index].iso ?? '',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: TextFormField(
                              scrollPhysics: const BouncingScrollPhysics(),
                              initialValue:
                                  searchCurrencies.value[index].name ?? '',
                              style: Theme.of(context).textTheme.bodyText2,
                              maxLines: 1,
                              readOnly: true,
                              onTap: () {
                                onPressed(context, index);
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: GestureDetector(
                              child: Icon(
                                Icons.info_outline,
                                color: Theme.of(context).focusColor,
                                size: 28.0,
                              ),
                              onTapDown: (TapDownDetails details) {
                                _tapPosition.value = details.globalPosition;
                              },
                              onTapUp: (TapUpDetails details) {
                                _showPopupMenu(
                                  context,
                                  searchCurrencies.value[index],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 30.0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
