import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 26.0),
      width: double.infinity,
      height: 37.0,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_outlined,
            color: Theme.of(context).disabledColor,
            size: 24.0,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск',
                hintStyle: Theme.of(context).textTheme.subtitle1,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
