import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  const DefaultTextField(
      {super.key, this.validator, this.keyboardType, required this.controller});
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
        child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            )));
  }
}
