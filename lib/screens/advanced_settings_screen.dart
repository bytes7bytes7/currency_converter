import 'package:flutter/material.dart';

import '../bloc/setting_bloc.dart';
import '../global_parameters.dart';

class AdvancedSettingsScreen extends StatelessWidget {
  const AdvancedSettingsScreen({
    Key? key,
  }) : super(key: key);

  void onPressed(ValueNotifier<String> notifier, String value) {
    if(notifier.value != value) {
      notifier.value = value;
      GlobalParameters.advancedSetting.value.value = notifier.value;
      SettingBloc.updateSettings([GlobalParameters.advancedSetting.value]);
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> selectedOption = ValueNotifier('');
    selectedOption.value = GlobalParameters.advancedSetting.value.value!;
    return Scaffold(
      appBar: const _AppBar(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedOption,
          builder: (context, selected, _) {
            return ListView.separated(
              itemCount:
              GlobalParameters.advancedSetting.value.options.length + 1,
              separatorBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox.shrink();
                } else {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    height: 1.0,
                    width: double.infinity,
                    color: Theme
                        .of(context)
                        .disabledColor
                        .withOpacity(0.25),
                  );
                }
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      GlobalParameters.advancedSetting.value.description,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,
                    ),
                  );
                } else {
                  String thisOption =
                  GlobalParameters.advancedSetting.value.options[index - 1];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        onPressed(selectedOption, thisOption);
                      },
                      child: SizedBox(
                        height: 44.0,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                thisOption,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText2,
                              ),
                              IconButton(
                                icon: (selectedOption.value == thisOption)
                                    ? const Icon(Icons.radio_button_on_outlined)
                                    : const Icon(
                                    Icons.radio_button_off_outlined),
                                splashRadius: 22.0,
                                onPressed: () {
                                  onPressed(selectedOption, thisOption);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
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
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          size: 28.0,
          color: Theme
              .of(context)
              .focusColor,
        ),
        splashColor: Theme
            .of(context)
            .disabledColor
            .withOpacity(0.25),
        splashRadius: 22.0,
        onPressed: () {
          GlobalParameters.screenController.animateToPage(
            2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      centerTitle: true,
      title: Text(
        GlobalParameters.advancedSetting.value.title!,
        style: Theme
            .of(context)
            .textTheme
            .headline1,
      ),
    );
  }
}
