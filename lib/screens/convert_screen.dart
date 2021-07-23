import 'package:currency_converter/bloc/exchange_bloc.dart';
import 'package:currency_converter/widgets/loading_circle.dart';
import 'package:flutter/material.dart';

import '../widgets/loading_label.dart';
import '../widgets/number_panel.dart';
import '../widgets/currency_input_field.dart';
import '../services/amount_text_input_formatter.dart';
import '../services/next_page_route.dart';
import '../models/currency.dart';
import '../bloc/info_bloc.dart';
import '../bloc/currency_bloc.dart';
import '../constants.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class ConvertScreen extends StatelessWidget {
  ConvertScreen({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Currency> currencyNotifier1 = ValueNotifier(Currency());
  final ValueNotifier<Currency> currencyNotifier2 = ValueNotifier(Currency());
  final TextEditingController currencyController1 = TextEditingController();
  final TextEditingController currencyController2 =
      TextEditingController(text: '0');
  final ValueNotifier<TextEditingController> textNotifier =
      ValueNotifier(TextEditingController());
  final AmountTextInputFormatter _formatter = AmountTextInputFormatter();

  void changeValue(String action) {
    if (currencyNotifier1.value.iso == null ||
        currencyNotifier2.value.iso == null) {
      return;
    }
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
                      ExchangeBloc.getFirstTwoCurrencies();
                      InfoDataState state = snapshot.data as InfoDataState;
                      String updated = state.date;
                      if (updated != ConstantDBData.unknown) {
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
                          updated =
                              '${ConstantData.month[date[3]]}, ${date[2]}';
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
                              CurrencyBloc.updateCurrencies();
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
                    } else if (snapshot.data is ExchangeDataState) {
                      ExchangeDataState state =
                          snapshot.data as ExchangeDataState;
                      if (state.exchanges.leftCurrency == null) {
                        return SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Нет загруженных данных\nНеобходим интернет',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        currencyNotifier1.value = state.exchanges.leftCurrency!;
                        currencyNotifier2.value =
                            state.exchanges.rightCurrency!;
                        currencyController1.text =
                            state.exchanges.leftValue?.toString() ?? '';
                        currencyController2.text =
                            state.exchanges.rightValue?.toString() ?? '';
                        return Column(
                          children: [
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
                              splashColor: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.25),
                              splashRadius: 22.0,
                              onPressed: () {
                                final String text = currencyController1.text;
                                currencyController1.text =
                                    currencyController2.text;
                                currencyController2.text = text;
                                final currency = currencyNotifier1.value;
                                currencyNotifier1.value =
                                    currencyNotifier2.value;
                                currencyNotifier2.value = currency;
                              },
                            ),
                            CurrencyInputField(
                              currencyNotifier: currencyNotifier2,
                              textEditingController: currencyController2,
                              textNotifier: textNotifier,
                            ),
                          ],
                        );
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
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
                nextPage: const HistoryScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
