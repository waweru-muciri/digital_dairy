import 'package:flutter/material.dart';

class FilterInputField extends StatelessWidget {
  const FilterInputField({super.key, required this.onQueryChanged});
  final void Function(String) onQueryChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16),
      child: TextFormField(
        onChanged: onQueryChanged,
        decoration: const InputDecoration(
          labelText: 'Search',
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
