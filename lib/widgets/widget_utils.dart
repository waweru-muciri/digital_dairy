import 'package:flutter/material.dart';

Future<void> showDeleteItemDialog(
    BuildContext context, Future<void> Function() deleteItemFuture) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(child: Text("Are you sure?")),
        content: const Text(
            'Permanently delete this item? This action cannot be undone!'),
        actions: <Widget>[
          OutlinedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FilledButton(
            child: const Text('Delete Item'),
            onPressed: () async {
              Navigator.of(context).pop();
              await deleteItemFuture();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showLoadingDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Dialog(
          // title: Center(child: Text("Loading...")),
          child: SizedBox(
              height: 200.0,
              width: 200.0,
              child: Transform.scale(
                scale: 0.3,
                child: const CircularProgressIndicator(
                  value: null,
                  semanticsLabel: "Loading",
                  strokeWidth: 6,
                ),
              )));
    },
  );
}

Future<DateTime?> showCustomDatePicker(
    BuildContext context, DateTime? initialDate) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101));
  return picked;
}
