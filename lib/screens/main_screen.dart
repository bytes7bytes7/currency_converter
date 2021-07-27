import 'package:flutter/material.dart';

import '../global_parameters.dart';
import '../screens/advanced_settings_screen.dart';
import '../screens/convert_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
