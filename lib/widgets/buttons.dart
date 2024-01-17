import 'package:flutter/material.dart';

FilledButton saveButton({Widget? child, required void Function()? onPressed}) {
  return FilledButton(
    onPressed: onPressed,
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ))),
    child: child ?? const Text("Save Details"),
  );
}
