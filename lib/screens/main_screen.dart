import 'package:flutter/material.dart';

import '../bloc/setup_bloc.dart';
import '../global_parameters.dart';
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
