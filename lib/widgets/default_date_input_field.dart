import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';

class DefaultDateTextField extends StatelessWidget {
  const DefaultDateTextField(
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
          readOnly: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            isDense: true,
            suffixIcon: IconButton(
                onPressed: () async {
                  final DateTime? pickedDateTime = await showCustomDatePicker(
                    context,
                    initialDate,
                  );
                  controller.text = getStringFromDate(pickedDateTime);
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
