import 'package:flutter/material.dart';

class FilterInputField extends StatelessWidget {
  const FilterInputField({super.key, required this.onQueryChanged});

  final void Function(String) onQueryChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: onQueryChanged,
        decoration: const InputDecoration(
          isDense: true,
          labelText: 'Search',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          // suffixIcon: IconButton(
          //     onPressed: () {
          //       debugPrint("fuck");
          //     },
          //     icon: const Icon(Icons.clear)),
        ));
  }
}
