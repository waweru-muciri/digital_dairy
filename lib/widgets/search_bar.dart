import 'package:flutter/material.dart';

class FilterInputField extends StatelessWidget {
  const FilterInputField({super.key, required this.onQueryChanged});

  final void Function(String) onQueryChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'Search',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.all(16),
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.search),
          // suffixIcon: IconButton(
          //     onPressed: () {
          //       debugPrint("fuck");
          //     },
          //     icon: const Icon(Icons.clear)),
        ));
  }
}
