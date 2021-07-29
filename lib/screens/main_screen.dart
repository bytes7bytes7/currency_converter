import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../models/setting.dart';
import '../bloc/setup_bloc.dart';
import '../global_parameters.dart';
import '../constants.dart';
import 'advanced_settings_screen.dart';
import 'convert_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder(
        stream: SetupBloc.setup,
        initialData: SetupInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is SetupInitState) {
            SetupBloc.setupAllSettings();
          } else if (snapshot.data is SetupDataState) {
            if (GlobalParameters.allSettings.isEmpty) {
              SetupBloc.addDefaultSettings();
            } else {
              SetupDataState state = snapshot.data as SetupDataState;
              Iterable<Setting> themeSetting = state.setup
                  .where((e) => e.title == ConstantDBData.themeParameter);
              if (themeSetting.isNotEmpty) {
                WidgetsBinding.instance!.addPostFrameCallback((_){
                  switch (themeSetting.first.value) {
                    case ConstantDBData.lightThemeValue:
                      AdaptiveTheme.of(context).setLight();
                      break;
                    case ConstantDBData.darkThemeValue:
                      AdaptiveTheme.of(context).setDark();
                      break;
                    case ConstantDBData.systemThemeValue:
                      AdaptiveTheme.of(context).setSystem();
                      break;
                  }
                });
              }
              // Iterable<Setting> historySetting = state.setup.where((e) => e.title==ConstantDBData.deleteHistory);
              // if(historySetting.isNotEmpty){
              //   DateTime now = DateTime.now();
              //   switch(historySetting.first.value){
              //     case ConstantDBData.deleteHistoryImmediately:
              //       break;
              //     case ConstantDBData.deleteHistoryDay:
              //       break;
              //     case ConstantDBData.deleteHistoryWeek:
              //       break;
              //     case ConstantDBData.deleteHistoryMonth:
              //       break;
              //     case ConstantDBData.deleteHistoryYear:
              //       break;
              //     case ConstantDBData.deleteHistoryNever:
              //       break;
              //   }
              // }
            }
          }
          if (GlobalParameters.allSettings.isEmpty) {
            return const SizedBox.shrink();
          } else {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalParameters.openAdvanced,
              builder: (context, open, _) {
                return PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: GlobalParameters.screenController,
                  scrollDirection: Axis.horizontal,
                  children: (open)
                      ? [
                          const HistoryScreen(),
                          ConvertScreen(),
                          const SettingsScreen(),
                          const AdvancedSettingsScreen(),
                        ]
                      : [
                          const HistoryScreen(),
                          ConvertScreen(),
                          const SettingsScreen(),
                        ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
