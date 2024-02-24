import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';

class MyDefaultDateInputTextField extends StatelessWidget {
  const MyDefaultDateInputTextField(
      {super.key, this.validator, this.initialDate, required this.controller});
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: TextFormField(
          controller: controller,
          validator: validator,
          readOnly: true,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
            suffixIcon: IconButton(
                onPressed: () async {
                  final DateTime? pickedDateTime = await showCustomDatePicker(
                    context,
                    getDateFromString(controller.text),
                  );
                  controller.value =
                      TextEditingValue(text: getStringFromDate(pickedDateTime));
                },
                icon: const Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.calendar_month,
                    ))),
          ),
        ));
  }
}
