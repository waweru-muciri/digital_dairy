import 'package:flutter/material.dart';

FilledButton saveButton({String? text, required void Function()? onPressed}) {
  return FilledButton(
    onPressed: onPressed,
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        )),
        minimumSize: MaterialStateProperty.all<Size>(const Size(100, 50)),
        textStyle:
            MaterialStateProperty.all<TextStyle>(const TextStyle().copyWith(
          fontSize: 16,
        ))),
    child: Text(text ?? "Save Details"),
  );
}
