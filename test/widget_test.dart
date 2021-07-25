import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEST',
      home: PerformancePage(),
    );
  }
}

class PerformancePage extends StatelessWidget {
  PerformancePage({
    Key? key,
  }) : super(key: key);

  final ValueNotifier<Future<void>> computeFuture = ValueNotifier(Future.value());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: computeFuture.value,
              builder: (context, snapshot) {
                return OutlinedButton(
                  child: const Text('Main Isolate'),
                  onPressed: createMainIsolateCallback(context, snapshot),
                );
              },
            ),
            FutureBuilder(
              future: computeFuture.value,
              builder: (context, snapshot) {
                return OutlinedButton(
                  child: const Text('Secondary Isolate'),
                  onPressed: createSecondaryIsolateCallback(context, snapshot),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback? createMainIsolateCallback(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        computeFuture.value = computeOnMainIsolate().then((val) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Main Isolate Done $val'),
          ));
        });
      };
    }
  }

  VoidCallback? createSecondaryIsolateCallback(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return () {
        computeFuture.value = computeOnSecondaryIsolate().then((val) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Secondary Isolate Done $val'),
          ));
        });
      };
    }
  }

  Future<int> computeOnMainIsolate() async {
    return await Future.delayed(
        const Duration(milliseconds: 100), () => fib(40));
  }

  Future<int> computeOnSecondaryIsolate() async {
    return await compute(fib, 40);
  }
}

int fib(int n) {
  int number1 = n - 1;
  int number2 = n - 2;
  if (0 == n) {
    return 0;
  } else if (1 == n) {
    return 1;
  } else {
    return (fib(number1) + fib(number2));
  }
}
