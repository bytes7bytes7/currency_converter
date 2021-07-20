import 'package:flutter/material.dart';

import 'themes/light_theme.dart';
import 'screens/convert_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      home: ConvertScreen(),
    );
  }
}
