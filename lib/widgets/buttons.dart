import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, this.onPressed, this.text});
  final void Function()? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          textStyle:
              MaterialStateProperty.all<TextStyle>(const TextStyle().copyWith(
            fontSize: 16,
          ))),
      child: Text(text ?? "Save Details"),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, this.onPressed, this.text});
  final void Function()? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          textStyle:
              MaterialStateProperty.all<TextStyle>(const TextStyle().copyWith(
            fontSize: 16,
          ))),
      child: Text(text ?? "Delete",
          style: const TextStyle(color: Colors.redAccent)),
    );
  }
}
