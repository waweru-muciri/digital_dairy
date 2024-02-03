import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FilterByDatesOrMonthDialog extends StatefulWidget {
  const FilterByDatesOrMonthDialog({super.key, required this.filterFunction});
  final void Function(String startDate, {String endDate}) filterFunction;

  @override
  State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends State<FilterByDatesOrMonthDialog> {
  late final TextEditingController yearController;

  int _selectedMonth = DateTime.now().month;
  final int _defaultYear = DateTime.now().year;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    yearController = TextEditingController(text: '$_defaultYear');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter By Month'),
      content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Column(
              children: [
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: TextFormField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        validator: (String? yearInput) {
                          if (yearInput != null && yearInput.isNotEmpty) {
                            int? year = int.tryParse(yearInput);
                            if (year == null) {
                              return "Year must be number!";
                            }
                            return null;
                          }
                          return "Year is required!";
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ))),
                Padding(
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
                                  child: Text(month.monthName)))
                          .toList(),
                      onChanged: (int? monthNumber) {
                        setState(() {
                          _selectedMonth = monthNumber ?? 0;
                        });
                      },
                      validator: (int? monthNumber) {
                        if (monthNumber == null) {
                          return "Month must be selected!";
                        }
                        return null;
                      },
                    )),
              ],
            )
          ])),
      actions: <Widget>[
        CancelButton(
            text: 'Reset',
            onPressed: () {
              _selectedMonth = DateTime.now().month;
            }),
        SaveButton(
            text: 'Apply Filters',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                int year = int.tryParse(yearController.text) ?? _defaultYear;
                DateTime startDateOfMonth = DateTime(year, _selectedMonth, 1);
                DateTime endDateOfMonth = DateTime(year, _selectedMonth + 1, 0);
                String startDateOfMonthString =
                    getStringFromDate(startDateOfMonth);
                String endDateOfMonthString = getStringFromDate(endDateOfMonth);
                widget.filterFunction(startDateOfMonthString,
                    endDate: endDateOfMonthString);
                Navigator.pop(context);
              }
            }),
      ],
    );
  }
}
