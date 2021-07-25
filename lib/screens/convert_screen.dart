import 'package:flutter/material.dart';

import '../widgets/loading_circle.dart';
import '../widgets/loading_label.dart';
import '../widgets/number_panel.dart';
import '../widgets/currency_input_field.dart';
import '../bloc/info_bloc.dart';
import '../bloc/currency_bloc.dart';
import '../bloc/exchange_bloc.dart';
import '../bloc/history_bloc.dart';
import '../models/currency.dart';
import '../models/exchange.dart';
import '../services/amount_text_input_formatter.dart';
import '../services/next_page_route.dart';
import '../constants.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class ConvertScreen extends StatelessWidget {
  ConvertScreen({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Exchange> exchangeNotifier = ValueNotifier(Exchange(
    leftCurrency: ValueNotifier(Currency()),
    rightCurrency: ValueNotifier(Currency()),
  ));
  final AmountTextInputFormatter _formatter = AmountTextInputFormatter();
  final ValueNotifier<double> currencyScrollOffset1 = ValueNotifier(0.0);
  final ValueNotifier<double> currencyScrollOffset2 = ValueNotifier(0.0);
  final ValueNotifier<String> lastAction = ValueNotifier('');

  void addToHistory() {
    DateTime now = DateTime.now();
    HistoryBloc.addExchange(Exchange(
      time: '${now.hour}:${now.minute} ${now.day}.${now.month}.${now.year} ${now.microsecond}',
      leftCurrency: exchangeNotifier.value.leftCurrency,
      rightCurrency: exchangeNotifier.value.rightCurrency,
    )
      ..leftValue.text = exchangeNotifier.value.leftValue.text
      ..rightValue.text = exchangeNotifier.value.rightValue.text);
  }

  void changeValue(String action) {
    if (exchangeNotifier.value.leftCurrency!.value.iso == null ||
        exchangeNotifier.value.rightCurrency!.value.iso == null) {
      return;
    }
    if (action == 'erase') {
      if (lastAction.value != 'erase') {
        addToHistory();
      }
      if (exchangeNotifier.value.leftValue.selection.end != 0 &&
          exchangeNotifier.value.leftValue.text.isNotEmpty) {
        final oldValue = exchangeNotifier.value.leftValue.value;
        final tmp = exchangeNotifier.value.leftValue.text.split('');
        if (exchangeNotifier.value.leftValue.selection.end == -1) {
          tmp.removeAt(exchangeNotifier.value.leftValue.text.length - 1);
        } else {
          tmp.removeAt(exchangeNotifier.value.leftValue.selection.end - 1);
        }
        int offset;
        if (exchangeNotifier.value.leftValue.selection.end == -1) {
          offset = -1;
        } else {
          offset = exchangeNotifier.value.leftValue.selection.end - 1;
        }
        TextEditingValue newValue = TextEditingValue(
          text: tmp.join(''),
          selection: TextSelection(
            baseOffset: offset,
            extentOffset: offset,
          ),
        );
        exchangeNotifier.value.leftValue.value =
            _formatter.formatEditUpdate(oldValue, newValue);
      }
    } else {
      TextEditingValue oldValue = exchangeNotifier.value.leftValue.value;
      final tmp = exchangeNotifier.value.leftValue.text.split('');
      if (exchangeNotifier.value.leftValue.selection.end == -1) {
        tmp.insert(exchangeNotifier.value.leftValue.text.length, action);
      } else {
        tmp.insert(exchangeNotifier.value.leftValue.selection.end, action);
      }
      int offset = exchangeNotifier.value.leftValue.selection.end;
      if (exchangeNotifier.value.leftValue.selection.end == -1) {
        offset = -1;
      } else if (action.isNotEmpty) {
        offset = exchangeNotifier.value.leftValue.selection.end + 1;
      }
      TextEditingValue newValue = TextEditingValue(
        text: tmp.join(''),
        selection: TextSelection(
          baseOffset: offset,
          extentOffset: offset,
        ),
      );
      exchangeNotifier.value.leftValue.value =
          _formatter.formatEditUpdate(oldValue, newValue);
    }
    final TextEditingValue oldValue = TextEditingValue(
      text: exchangeNotifier.value.rightValue.text,
    );
    final String currText1 = exchangeNotifier.value.leftValue.text
        .replaceAll(',', '.')
        .replaceAll(' ', '');
    if (currText1.isNotEmpty) {
      double v = (double.parse(currText1) *
          exchangeNotifier.value.rightCurrency!.value.rate! /
          exchangeNotifier.value.leftCurrency!.value.rate!);
      TextEditingValue newValue;
      if (v.toInt() == 0) {
        newValue = TextEditingValue(
          text: v.toString().replaceAll('.', ','),
        );
      } else {
        newValue = TextEditingValue(
          text: v.toStringAsFixed(2).replaceAll('.', ','),
        );
      }
      exchangeNotifier.value.rightValue.text =
          _formatter.formatEditUpdate(oldValue, newValue).text;
    } else {
      exchangeNotifier.value.rightValue.text = '';
    }
    lastAction.value = action;
  }

  void cleanField() {
    if (lastAction.value != 'erase') {
      addToHistory();
    }
    exchangeNotifier.value.leftValue.text = '';
    exchangeNotifier.value.rightValue.text = '';
    lastAction.value = 'erase';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _AppBar(
        exchangeNotifier: exchangeNotifier,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                StreamBuilder(
                  stream: InfoBloc.info,
                  initialData: InfoInitState(),
                  builder: (context, snapshot) {
                    if (snapshot.data is InfoInitState) {
                      InfoBloc.getLastDate();
                      return RawMaterialButton(
                        splashColor:
                            Theme.of(context).disabledColor.withOpacity(0.25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.language_outlined,
                              color: Colors.transparent,
                              size: 20.0,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              '',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                        onPressed: () {},
                      );
                    } else if (snapshot.data is InfoLoadingState) {
                      return const LoadingLabel();
                    } else if (snapshot.data is InfoDataState) {
                      if (exchangeNotifier.value.leftCurrency!.value.iso ==
                              null ||
                          exchangeNotifier.value.rightCurrency!.value.iso ==
                              null) {
                        ExchangeBloc.getFirstTwoCurrencies();
                      } else {
                        ExchangeBloc.updateCalculation();
                      }
                      InfoDataState state = snapshot.data as InfoDataState;
                      String updated = state.date;
                      if (updated == ConstantDBData.unknown) {
                        CurrencyBloc.updateCurrencies();
                      } else {
                        List<int> date = state.date
                            .split(RegExp('[: .]'))
                            .map<int>((e) => int.parse(e))
                            .toList();
                        DateTime now = DateTime.now();
                        if (date[4] != now.year) {
                          String day = date[2].toString();
                          if (day.length < 2) {
                            day = '0' + day;
                          }
                          String month = date[3].toString();
                          if (month.length < 2) {
                            month = '0' + month;
                          }
                          updated = '$day.$month.${date[4]}';
                        } else if (date[3] != now.month || date[2] != now.day) {
                          updated = '${date[2]} ${ConstantData.month[date[3]]}';
                        } else {
                          String hour = date[0].toString();
                          if (hour.length < 2) {
                            hour = '0' + hour;
                          }
                          String minute = date[1].toString();
                          if (minute.length < 2) {
                            minute = '0' + minute;
                          }
                          updated = '$hour:$minute';
                        }
                      }
                      return SizedBox(
                        height: 24,
                        child: RawMaterialButton(
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
                                'Обновлено: $updated',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          ),
                          onPressed: () {
                            if (snapshot.data is! InfoLoadingState) {
                              String left =
                                  exchangeNotifier.value.leftValue.text;
                              String right =
                                  exchangeNotifier.value.rightValue.text;
                              DateTime now = DateTime.now();
                              CurrencyBloc.updateCurrencies().then((_) {
                                ExchangeBloc.updateExchange(Exchange(
                                  time:
                                      '${now.hour}:${now.minute} ${now.day}.${now.month}.${now.year}',
                                  leftCurrency:
                                      exchangeNotifier.value.leftCurrency,
                                  rightCurrency:
                                      exchangeNotifier.value.rightCurrency,
                                )
                                      ..leftValue.text = left
                                          .replaceAll(',', '.')
                                          .replaceAll(' ', '')
                                      ..rightValue.text = right
                                          .replaceAll(',', '.')
                                          .replaceAll(' ', ''))
                                    .then((_) {
                                  changeValue('');
                                });
                              });
                            }
                          },
                        ),
                      );
                    } else if (snapshot.data is InfoLoadingErrorState) {
                      return FutureBuilder(
                        future: Future.delayed(
                            const Duration(seconds: 2), () => 'ok'),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            InfoBloc.getLastDate();
                          }
                          return SizedBox(
                            height: 24,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline_outlined,
                                  color: Theme.of(context).disabledColor,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  'Ошибка',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const Spacer(
                  flex: 1,
                ),
                StreamBuilder(
                  stream: ExchangeBloc.exchange,
                  initialData: ExchangeInitState(),
                  builder: (context, snapshot) {
                    if (snapshot.data is ExchangeInitState) {
                      return const SizedBox.shrink();
                    } else if (snapshot.data is ExchangeLoadingState) {
                      return const SizedBox(
                        height: 28.0,
                        width: 28.0,
                        child: LoadingCircle(),
                      );
                    } else if (snapshot.data is ExchangeDataState ||
                        snapshot.data is ExchangeUpdateCalculationState) {
                      if (snapshot.data is ExchangeDataState) {
                        ExchangeDataState state =
                            snapshot.data as ExchangeDataState;
                        if (state.exchange.leftCurrency == null) {
                          return SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Нет загруженных данных\nНеобходим интернет',
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          exchangeNotifier.value.leftCurrency =
                              state.exchange.leftCurrency!;
                          exchangeNotifier.value.rightCurrency =
                              state.exchange.rightCurrency!;
                          exchangeNotifier.value.leftValue.text =
                              state.exchange.leftValue.text;
                          exchangeNotifier.value.rightValue.text =
                              state.exchange.rightValue.text;
                        }
                      } else {
                        changeValue('');
                      }
                      return Column(
                        children: [
                          CurrencyInputField(
                            currencyNotifier:
                                exchangeNotifier.value.leftCurrency!,
                            textEditingController:
                                exchangeNotifier.value.leftValue,
                            currencyScrollOffset: currencyScrollOffset1,
                            addToHistory: addToHistory,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.swap_vert_outlined,
                              color: Theme.of(context).focusColor,
                              size: 28.0,
                            ),
                            splashColor: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.25),
                            splashRadius: 22.0,
                            onPressed: () {
                              final Currency currency =
                                  exchangeNotifier.value.leftCurrency!.value;
                              exchangeNotifier.value.leftCurrency!.value =
                                  exchangeNotifier.value.rightCurrency!.value;
                              exchangeNotifier.value.rightCurrency!.value =
                                  currency;
                              final double offset = currencyScrollOffset1.value;
                              currencyScrollOffset1.value =
                                  currencyScrollOffset2.value;
                              currencyScrollOffset2.value = offset;
                              changeValue('');
                            },
                          ),
                          CurrencyInputField(
                            enabled: false,
                            currencyNotifier:
                                exchangeNotifier.value.rightCurrency!,
                            textEditingController:
                                exchangeNotifier.value.rightValue,
                            currencyScrollOffset: currencyScrollOffset2,
                            addToHistory: addToHistory,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const Spacer(
                  flex: 2,
                ),
                NumberPanel(
                  onTap: changeValue,
                  onLongPress: cleanField,
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
    required this.exchangeNotifier,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  final ValueNotifier<Exchange> exchangeNotifier;

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
          Navigator.push(
            context,
            NextPageRoute(
              nextPage: const SettingsScreen(),
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
            Navigator.push(
              context,
              NextPageRoute(
                nextPage: HistoryScreen(
                  exchangeNotifier: exchangeNotifier,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
