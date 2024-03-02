import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:flutter/material.dart';

Chip getActiveStatusChip(BuildContext context, bool activeStatus) {
  return Chip(
      backgroundColor: activeStatus
          ? Colors.tealAccent.withOpacity(0.1)
          : Colors.redAccent.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      side: ChipTheme.of(context)
          .copyWith(
              side: BorderSide(
                  color: activeStatus
                      ? Colors.tealAccent.withOpacity(0.3)
                      : Colors.redAccent.withOpacity(0.3)))
          .side,
      labelPadding: const EdgeInsets.all(0),
      visualDensity: const VisualDensity(horizontal: 0.0, vertical: -2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      label: Text(
        activeStatus ? "Active" : "Inactive",
      ));
}

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
          CancelButton(
            text: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          DeleteButton(
            text: 'Delete Item',
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
      return const AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 6),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
          ],
        ),
      );
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
      lastDate: DateTime.now());
  return picked;
}

Future<Map<String, String>?> showDatesFilterBottomSheet(
    BuildContext context,
    TextEditingController fromDateFilterController,
    TextEditingController toDateFilterController) {
  return showModalBottomSheet<Map<String, String>?>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Filter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          controller: fromDateFilterController,
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: 'From Date',
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? pickedDateTime =
                                      await showCustomDatePicker(
                                          context,
                                          getDateFromString(
                                              fromDateFilterController.text));
                                  fromDateFilterController.text =
                                      getStringFromDate(pickedDateTime);
                                },
                                icon: const Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(
                                      Icons.calendar_month,
                                    ))),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TextFormField(
                          controller: toDateFilterController,
                          readOnly: true,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: 'To Date',
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  final DateTime? pickedDateTime =
                                      await showCustomDatePicker(
                                          context,
                                          getDateFromString(
                                              toDateFilterController.text));

                                  toDateFilterController.text =
                                      getStringFromDate(pickedDateTime);
                                },
                                icon: const Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Icon(
                                      Icons.calendar_month,
                                    ))),
                          ),
                        )),
                  ),
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FilledButton(
                      child: const Text('Apply Filters'),
                      onPressed: () {
                        Navigator.pop(context, {
                          'start_date': fromDateFilterController.text,
                          'end_date': toDateFilterController.text
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget summaryTextDisplayRow(String summaryText, String dataText) {
  return Row(children: <Widget>[
    Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            summaryText,
            style: const TextStyle(
                color: Color(0xdd000000),
                decoration: TextDecoration.none,
                fontFamily: "Lato",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
                textBaseline: TextBaseline.alphabetic),
          ),
        )),
    Expanded(flex: 1, child: Text(dataText))
  ]);
}

Widget inputFieldLabel(BuildContext context, String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );
}

IconButton getFilterIconButton({required void Function()? onPressed}) {
  return IconButton(onPressed: onPressed, icon: const Icon(Icons.filter_list));
}
