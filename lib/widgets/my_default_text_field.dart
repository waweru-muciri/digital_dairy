import 'package:flutter/material.dart';

class MyDefaultTextField extends StatelessWidget {
  const MyDefaultTextField(
      {super.key,
      this.validator,
      this.keyboardType,
      this.minLines,
      this.maxLines,
      required this.controller});
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
        child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
            validator: validator,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            )));
  }
}
