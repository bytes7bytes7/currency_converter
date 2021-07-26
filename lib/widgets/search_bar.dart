import 'package:flutter/material.dart';

import '../models/currency.dart';

class SearchBar extends SearchDelegate<Currency> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
          height: 100.0,
          width: double.infinity,
          color: Colors.lightBlueAccent,
        );
      },
    );
  }
}
