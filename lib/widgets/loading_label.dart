import 'package:flutter/material.dart';

class LoadingLabel extends StatelessWidget {
  const LoadingLabel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              color: Theme.of(context).disabledColor,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 5.0),
          Text(
            'Обновление',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
