import 'package:flutter/material.dart';

import '../global_parameters.dart';
import '../widgets/loading_circle.dart';
import '../bloc/setting_bloc.dart';
import '../models/setting.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<Setting, ValueNotifier<dynamic>> data = {};
    return Scaffold(
      appBar: _AppBar(
        data: data,
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: SettingBloc.setting,
            initialData: SettingInitState(),
            builder: (context, snapshot) {
              if (snapshot.data is SettingInitState) {
                SettingBloc.getSettings();
                return const SizedBox.shrink();
              } else if (snapshot.data is SettingLoadingState) {
                return const SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: LoadingCircle(),
                );
              } else if (snapshot.data is SettingDataState) {
                SettingDataState state = snapshot.data as SettingDataState;
                if (state.settings.isEmpty) {
                  SettingBloc.addDefaultSettings();
                  return Center(
                    child: Text(
                      'Пусто',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  );
                } else {
                  return _SettingList(
                    settings: state.settings,
                    data: data,
                  );
                }
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
    required this.data,
  }) : super(key: key);

  final Map<Setting, ValueNotifier<dynamic>> data;

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
          List<Setting> settings = List.from(data.keys);
          List<ValueNotifier<dynamic>> notifiers = List.from(data.values);
          for (int i = 0; i < settings.length; i++) {
            settings[i].value = notifiers[i].value.toString();
          }
          SettingBloc.updateSettings(settings);
          GlobalParameters.screenController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      centerTitle: true,
      title: Text(
        'Настройки',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class _SettingList extends StatelessWidget {
  const _SettingList({
    Key? key,
    required this.settings,
    required this.data,
  }) : super(key: key);

  final List<Setting> settings;
  final Map<Setting, ValueNotifier<dynamic>> data;

  void onPressed(Setting setting, ValueNotifier<dynamic> notifier) {
    notifier.value = !notifier.value;
    setting.value = notifier.value.toString();
    SettingBloc.updateSettings([setting]);
  }

  @override
  Widget build(BuildContext context) {
    List<ValueNotifier<dynamic>> valueList = [];
    return Scrollbar(
      thickness: 8,
      radius: const Radius.circular(5),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: settings.length,
        separatorBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            height: 1.0,
            width: double.infinity,
            color: Theme.of(context).disabledColor.withOpacity(0.25),
          );
        },
        itemBuilder: (context, index) {
          switch (settings[index].value) {
            case 'true':
              valueList.add(ValueNotifier<bool>(true));
              break;
            case 'false':
              valueList.add(ValueNotifier<bool>(false));
              break;
            default:
              valueList.add(ValueNotifier<String>(settings[index].value!));
          }
          data[settings[index]] = valueList[index];
          IconData icon;
          switch (settings[index].icon) {
            case 'dark_mode_outlined':
              icon = Icons.dark_mode_outlined;
              break;
            case 'save_alt_outlined':
              icon = Icons.save_alt_outlined;
              break;
            case 'update_outlined':
              icon = Icons.update_outlined;
              break;
            case 'save':
              icon = Icons.save;
              break;
            case 'auto_delete_outlined':
              icon = Icons.auto_delete_outlined;
              break;
            default:
              icon = Icons.help_outline_outlined;
              break;
          }
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            child: RawMaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                if (valueList[index].value is bool) {
                  onPressed(settings[index], valueList[index]);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).focusColor,
                      size: 30.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settings[index].title!,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Text(
                            settings[index].subtitle!,
                            style: Theme.of(context).textTheme.subtitle1,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: valueList[index],
                      builder: (context, _, __) {
                        if (valueList[index].value is bool) {
                          return Checkbox(
                            value: valueList[index].value,
                            onChanged: (value) {
                              onPressed(settings[index], valueList[index]);
                            },
                            fillColor: MaterialStateProperty.all(
                                Theme.of(context).focusColor),
                            activeColor: Theme.of(context).focusColor,
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_outlined),
                            onPressed: () {},
                          );
                        }
                      },
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
