import 'package:flutter/material.dart';

class FilterInputField extends StatelessWidget {
  const FilterInputField({super.key, required this.onQueryChanged});

  final void Function(String) onQueryChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 7)
          ]),
      child: TextFormField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            hintStyle: TextStyle(color: Colors.grey[800]),
            isDense: true,
            hintText: 'Search',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: const EdgeInsets.all(12),
            prefixIcon: const Icon(Icons.search),
            // suffixIcon: IconButton(
            //     onPressed: () {
            //       debugPrint("fuck");
            //     },
            //     icon: const Icon(Icons.clear)),
          )),
    );
  }
}
