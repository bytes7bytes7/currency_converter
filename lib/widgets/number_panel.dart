import 'package:flutter/material.dart';

import 'circle_button.dart';

class NumberPanel extends StatelessWidget {
  const NumberPanel({
    Key? key,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  final Function onTap;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = size.height * 0.475;
    const double buttonWidth = 70.0;
    return LayoutBuilder(builder: (context, constraints) {
      final double xSpace = (constraints.maxWidth - 3 * buttonWidth) / 2;
      final double ySpace = (height - 4 * buttonWidth) / 3;
      final double space = (xSpace < ySpace) ? xSpace : ySpace;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: '7 8 9'.characters.map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return CircleButton(
                  buttonWidth: buttonWidth,
                  data: e,
                  onTap: () {
                    onTap(e);
                  },
                  onLongPress: () {
                    onLongPress();
                  },
                );
              }
            }).toList(),
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: '4 5 6'.characters.map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return CircleButton(
                  buttonWidth: buttonWidth,
                  data: e,
                  onTap: () {
                    onTap(e);
                  },
                  onLongPress: () {
                    onLongPress();
                  },
                );
              }
            }).toList(),
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: '1 2 3'.characters.map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return CircleButton(
                  buttonWidth: buttonWidth,
                  data: e,
                  onTap: () {
                    onTap(e);
                  },
                  onLongPress: () {
                    onLongPress();
                  },
                );
              }
            }).toList(),
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [',', ' ', '0', ' ', 'erase'].map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return CircleButton(
                  buttonWidth: buttonWidth,
                  data: e,
                  onTap: () {
                    onTap(e);
                  },
                  onLongPress: () {
                    onLongPress();
                  },
                );
              }
            }).toList(),
          ),
        ],
      );
    });
  }
}
