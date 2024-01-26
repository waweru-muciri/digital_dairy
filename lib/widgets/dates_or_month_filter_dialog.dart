import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';

class FilterByDatesOrMonthDialog extends StatefulWidget {
  const FilterByDatesOrMonthDialog({super.key, required this.filterFunction});
  final void Function(String startDate, {String endDate}) filterFunction;

  @override
  State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends State<FilterByDatesOrMonthDialog> {
  TextEditingController fromDateFilterController = TextEditingController();
  TextEditingController toDateFilterController = TextEditingController();
  TextEditingController yearController = TextEditingController(text: "2023");

  String filterByDateOrMonth = "date";
  int _selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Filter'),
      children: <Widget>[
        Row(
          children: [
            const Expanded(child: Text("Filter by month")),
            Expanded(
                child: Radio<String>(
              value: 'month',
              groupValue: filterByDateOrMonth,
              onChanged: (String? value) {
                setState(() {
                  filterByDateOrMonth = value ?? 'month';
                });
              },
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: TextFormField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        validator: (String? yearInput) {
                          if (filterByDateOrMonth == "month" &&
                              yearInput != null &&
                              yearInput.isNotEmpty) {
                            int? year = int.tryParse(yearInput);
                            if (year == null) return "Year must be number!";
                          }
                          return "Year is required!";
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        )))),
            Expanded(
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                  child: DropdownButtonFormField<int>(
                    isExpanded: true,
                    value: _selectedMonth,
                    isDense: true,
                    iconEnabledColor: Colors.green,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    items: MonthsOfTheYear.values
                        .map<DropdownMenuItem<int>>((month) =>
                            DropdownMenuItem<int>(
                                value: month.monthNumber,
                                child: Text(month.month)))
                        .toList(),
                    onChanged: (int? monthNumber) {
                      setState(() {
                        _selectedMonth = monthNumber ?? 0;
                      });
                    },
                    validator: (int? monthNumber) {
                      if (filterByDateOrMonth == "month") {
                        if (monthNumber == null) {
                          return "Month must be selected!";
                        }
                      }
                      return null;
                    },
                  )),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(child: Text("Filter by dates")),
            Expanded(
                child: Radio<String>(
              value: 'month',
              groupValue: filterByDateOrMonth,
              onChanged: (String? value) {
                setState(() {
                  filterByDateOrMonth = value ?? 'month';
                });
              },
            )),
          ],
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
                child: const Text('Reset'),
                onPressed: () {
                  fromDateFilterController.clear();
                  toDateFilterController.clear();
                }),
            FilledButton(
                child: const Text('Apply Filters'),
                onPressed: () {
                  widget.filterFunction(fromDateFilterController.text,
                      endDate: toDateFilterController.text);
                  Navigator.pop(context);
                }),
          ],
        )
      ],
    );
  }
}
