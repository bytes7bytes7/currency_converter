import 'package:flutter/material.dart';

class NumberPanel extends StatelessWidget {
  const NumberPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: '789'.characters.map((e) {
              return Container(
                height: 70.0,
                width: 70.0,
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
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: '456'.characters.map((e) {
              return Container(
                height: 70.0,
                width: 70.0,
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
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: '123'.characters.map((e) {
              return Container(
                height: 70.0,
                width: 70.0,
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
            }).toList(),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [',', '0', Icons.backspace_outlined].map((e) {
              return Container(
                height: 70.0,
                width: 70.0,
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
            }).toList(),
          ),
        ],
      ),
    );
  }
}
