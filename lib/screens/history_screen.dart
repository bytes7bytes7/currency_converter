import 'package:currency_converter/widgets/show_no_yes_dialog.dart';
import 'package:flutter/material.dart';

import '../bloc/history_bloc.dart';
import '../widgets/loading_circle.dart';
import '../models/exchange.dart';
import '../constants.dart';
import '../global_parameters.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: HistoryBloc.history,
            initialData: HistoryInitState(),
            builder: (context, snapshot) {
              if (snapshot.data is HistoryInitState) {
                HistoryBloc.getAllExchanges();
                return const SizedBox.shrink();
              }
              if (snapshot.data is HistoryLoadingState) {
                return const Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: LoadingCircle(),
                  ),
                );
              } else if (snapshot.data is HistoryDataState) {
                HistoryDataState state = snapshot.data as HistoryDataState;
                if (state.exchanges.isEmpty) {
                  return Center(
                    child: Text(
                      'Пусто',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  );
                }
                return _HistoryList(
                  exchanges: state.exchanges,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
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
          Icons.delete_outline_outlined,
          size: 28.0,
          color: Theme.of(context).focusColor,
        ),
        splashColor: Theme.of(context).disabledColor.withOpacity(0.25),
        splashRadius: 22.0,
        onPressed: () {
          showNoYesDialog(
            context: context,
            title: 'Удалить историю?',
            subtitle: 'Отменить действие будет невозможно',
            noAnswer: () {
              Navigator.pop(context);
            },
            yesAnswer: () {
              HistoryBloc.deleteAllExchanges();
              Navigator.pop(context);
            },
          );
        },
      ),
      centerTitle: true,
      title: Text(
        'История',
        style: Theme.of(context).textTheme.headline1,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            size: 28.0,
            color: Theme.of(context).focusColor,
          ),
          splashColor: Theme.of(context).disabledColor.withOpacity(0.25),
          splashRadius: 22.0,
          onPressed: () {
            GlobalParameters.screenController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    Key? key,
    required this.exchanges,
  }) : super(key: key);

  final List<Exchange> exchanges;

  void onPressed(BuildContext context, int index) {
    GlobalParameters.exchangeNotifier.value
      ..leftValue.value = exchanges[index].leftValue.value
      ..rightValue.value = exchanges[index].rightValue.value
      ..leftCurrency!.value = exchanges[index].leftCurrency!.value
      ..rightCurrency!.value = exchanges[index].rightCurrency!.value;
    GlobalParameters.screenController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 8,
      radius: const Radius.circular(5),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: exchanges.length,
        separatorBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            height: 1.0,
            width: double.infinity,
            color: Theme.of(context).disabledColor.withOpacity(0.25),
          );
        },
        itemBuilder: (context, index) {
          String time = '';
          List<int> date = exchanges[index]
              .time
              .toString()
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
            time = '$day.$month.${date[4]}';
          } else if (date[3] != now.month || date[2] != now.day) {
            time = '${ConstantData.month[date[3]]}, ${date[2]}';
          } else {
            String hour = date[0].toString();
            if (hour.length < 2) {
              hour = '0' + hour;
            }
            String minute = date[1].toString();
            if (minute.length < 2) {
              minute = '0' + minute;
            }
            time = '$hour:$minute';
          }
          String leftFlag = exchanges[index].leftCurrency!.value.iso != null
              ? exchanges[index].leftCurrency!.value.getFlag()
              : '';
          String rightFlag = exchanges[index].rightCurrency!.value.iso != null
              ? exchanges[index].rightCurrency!.value.getFlag()
              : '';
          String leftValue = exchanges[index].leftValue.text;
          if (leftValue.isEmpty) {
            leftValue = '0';
          }
          if (leftValue.contains(',')) {
            if (double.parse(
                    leftValue.replaceAll(',', '.').replaceAll(' ', '')) ==
                double.parse(leftValue.replaceAll(',', '.').replaceAll(' ', ''))
                    .toInt()) {
              leftValue = leftValue.substring(0, leftValue.indexOf(','));
            }
            leftValue = leftValue.replaceAll('.', ',');
          }
          String rightValue = exchanges[index].rightValue.text;
          if (rightValue.isEmpty) {
            rightValue = '0';
          }
          if (rightValue.contains(',')) {
            if (double.parse(
                    rightValue.replaceAll(',', '.').replaceAll(' ', '')) ==
                double.parse(
                        rightValue.replaceAll(',', '.').replaceAll(' ', ''))
                    .toInt()) {
              rightValue = rightValue.substring(0, rightValue.indexOf(','));
            }
            rightValue = rightValue.replaceAll('.', ',');
          }
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 90.0,
            child: RawMaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                onPressed(context, index);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: (leftFlag.isNotEmpty &&
                                        leftFlag.contains('.png'))
                                    ? Image.asset(
                                        'assets/png/additional_flags/$leftFlag')
                                    : RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: leftFlag,
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
                                exchanges[index].leftCurrency!.value.iso ?? '',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Text(
                            time,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: (rightFlag.isNotEmpty &&
                                        rightFlag.contains('.png'))
                                    ? Image.asset(
                                        'assets/png/additional_flags/$rightFlag')
                                    : RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: rightFlag,
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
                                exchanges[index].rightCurrency!.value.iso ?? '',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextFormField(
                            scrollPhysics: const BouncingScrollPhysics(),
                            initialValue: leftValue,
                            style: Theme.of(context).textTheme.headline1,
                            maxLines: 1,
                            readOnly: true,
                            onTap: () {
                              onPressed(context, index);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Theme.of(context).focusColor,
                            size: 40.0,
                          ),
                        ),
                        Flexible(
                          child: TextFormField(
                            scrollPhysics: const BouncingScrollPhysics(),
                            initialValue: rightValue,
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            readOnly: true,
                            onTap: () {
                              onPressed(context, index);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
