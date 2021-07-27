import 'package:currency_converter/global_parameters.dart';
import 'package:currency_converter/screens/convert_screen.dart';
import 'package:currency_converter/screens/history_screen.dart';
import 'package:currency_converter/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const BouncingScrollPhysics(),
      controller: GlobalParameters.screenController,
      scrollDirection: Axis.horizontal,
      children: [
        const HistoryScreen(),
        ConvertScreen(),
        const SettingsScreen(),
      ],
    );
  }
}
