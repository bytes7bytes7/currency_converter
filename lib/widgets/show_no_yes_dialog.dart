import 'package:flutter/material.dart';

Future<void> showNoYesDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Function noAnswer,
  required Function yesAnswer,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // true - user can dismiss dialog
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 25.0),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                      ),
                      child: RawMaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: Border(
                          top: BorderSide(
                            color: Theme.of(context).focusColor.withOpacity(0.25),
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Theme.of(context).focusColor.withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Нет',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        onPressed: () {
                          noAnswer();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                      ),
                      child: RawMaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: Border(
                          top: BorderSide(
                            color: Theme.of(context).focusColor.withOpacity(0.25),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'Да',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        onPressed: () {
                          yesAnswer();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.all(0),
      );
    },
  );
}
