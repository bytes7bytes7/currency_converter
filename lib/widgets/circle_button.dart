import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    Key? key,
    required this.buttonWidth,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final double buttonWidth;
  final String data;
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
            onTap: () {
              onTap();
            },
            child: CircleAvatar(
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: Center(
                child: (data == 'erase')
                    ? Icon(
                        Icons.backspace_outlined,
                        size: 28.0,
                        color: Theme.of(context).focusColor,
                      )
                    : Text(
                        data,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
