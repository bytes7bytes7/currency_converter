import 'package:flutter/material.dart';

class NumberPanel extends StatelessWidget {
  const NumberPanel({
    Key? key,
  }) : super(key: key);

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
                return Container(
                  height: buttonWidth,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.25),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                );
              }
            }).toList(),
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: '7 8 9'.characters.map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return Container(
                  height: buttonWidth,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.25),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                );
              }
            }).toList(),
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: '7 8 9'.characters.map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return Container(
                  height: buttonWidth,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.25),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      e,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                );
              }
            }).toList(),
          ),
          SizedBox(height: space),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [',', ' ', '0', ' ', Icons.backspace_outlined].map((e) {
              if (e == ' ') {
                return SizedBox(width: space);
              } else {
                return Container(
                  height: buttonWidth,
                  width: buttonWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.25),
                        offset: const Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: (e is IconData)
                        ? Icon(
                            e,
                            size: 28.0,
                            color: Theme.of(context).focusColor,
                          )
                        : Text(
                            e.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                  ),
                );
              }
            }).toList(),
          ),
        ],
      );
    });
  }
}
