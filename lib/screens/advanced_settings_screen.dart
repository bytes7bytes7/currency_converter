import 'package:flutter/material.dart';

import '../models/setting.dart';
import '../global_parameters.dart';

class AdvancedSettingsScreen extends StatelessWidget {
  const AdvancedSettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<Setting, ValueNotifier<dynamic>> data = {};
    return Scaffold(
      appBar: _AppBar(
        data: data,
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
          GlobalParameters.screenController.animateToPage(
            2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
      centerTitle: true,
      title: Text(
        'Дополнительно',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
