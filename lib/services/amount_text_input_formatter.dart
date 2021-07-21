import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextInputFormatter extends TextInputFormatter {
  bool onlyOne(List<String> lst, String subStr) {
    return lst.indexOf(subStr) == lst.lastIndexOf(subStr) &&
        lst.contains(subStr);
  }

  int countCommaAndPoint(List<String> lst) {
    int quantity = 0;
    for (int i = 0; i < lst.length; i++) {
      if (lst[i] == '.' || lst[i] == ',') {
        quantity++;
      }
    }
    return quantity;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedValue = '';
    int cursorPosition = newValue.selection.end;

    // TODO: I can add condition to check if a space has been deleted

    List<String> integer = newValue.text.split('');
    String divider = '';
    List<String> fractional = [];

    if (onlyOne(integer, '.') && !integer.contains(',')) {
      fractional.addAll(integer.sublist(integer.indexOf('.') + 1));
      divider = '.';
      integer = integer.sublist(0, integer.indexOf('.'));
    } else if (onlyOne(integer, ',') && !integer.contains('.')) {
      fractional.addAll(integer.sublist(integer.indexOf(',') + 1));
      divider = ',';
      integer = integer.sublist(0, integer.indexOf(','));
    } else if (!integer.contains('.') && !integer.contains(',')) {
      // integer number
    } else {
      // To many dividers (comma & point)
      if (integer.contains('.') && !integer.contains(',')) {
        fractional.addAll(integer.sublist(integer.indexOf('.') + 1));
        divider = '.';
        integer = integer.sublist(0, integer.indexOf('.'));
      } else if (integer.contains(',') && !integer.contains('.')) {
        fractional.addAll(integer.sublist(integer.indexOf(',') + 1));
        divider = ',';
        integer = integer.sublist(0, integer.indexOf(','));
      } else {
        if (integer.indexOf('.') < integer.indexOf(',') &&
            integer.contains('.')) {
          fractional.addAll(integer.sublist(integer.indexOf('.') + 1));
          divider = '.';
          integer = integer.sublist(0, integer.indexOf('.'));
        } else {
          fractional.addAll(integer.sublist(integer.indexOf(',') + 1));
          divider = ',';
          integer = integer.sublist(0, integer.indexOf(','));
        }
      }
    }

    for (int i = fractional.length - 1; i >= 0; i--) {
      if (fractional[i] == ' ') {
        if (integer.length + 1 + i < cursorPosition) {
          cursorPosition--;
        }
        fractional.removeAt(i);
      }
    }

    for (int i = integer.length - 1; i >= 0; i--) {
      if (integer[i] == ' ') {
        if (i < cursorPosition) {
          cursorPosition--;
        }
        integer.removeAt(i);
      }
    }

    if (integer.length % 3 != 0) {
      formattedValue = integer.sublist(0, integer.length % 3).join('');
      for (int i = integer.length % 3 - 1; i >= 0; i--) {
        integer.removeAt(i);
      }
    }
    int parts = integer.length ~/ 3;
    for (int i = 0; i < parts; i++) {
      if (formattedValue != '') {
        formattedValue += ' ';
        if (cursorPosition >= formattedValue.length) {
          cursorPosition++;
        }
      }
      formattedValue += integer.sublist(i * 3, (i + 1) * 3).join('');
    }

    formattedValue += divider + fractional.join('');

    // print(formattedValue + '#');
    // print(' ' * cursorPosition + '#');

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
