import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key? key,
    required this.buttonWidth,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final double buttonWidth;
  final dynamic data;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
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
      child: ClipOval(
        child: Material(
          child: InkWell(
            splashColor: Theme.of(context).disabledColor,
            onTap: () {},
            child: CircleAvatar(
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Center(
                child: (data is IconData)
                    ? Icon(
                        data,
                        size: 28.0,
                        color: Theme.of(context).focusColor,
                      )
                    : (data is String)
                        ? Text(
                            data,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
