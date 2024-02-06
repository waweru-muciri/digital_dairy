import 'package:DigitalDairy/util/utils.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FilterByDatesOrMonthDialog extends StatefulWidget {
  FilterByDatesOrMonthDialog({super.key, this.initialYear, this.initialMonth});

  int? initialYear;
  int? initialMonth;

  @override
  State<StatefulWidget> createState() => ScreenState();
}

class ScreenState extends State<FilterByDatesOrMonthDialog> {
  late final TextEditingController yearController;

  late int _selectedMonth;
  late int _defaultYear;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _defaultYear = widget.initialYear ?? DateTime.now().year;
    _selectedMonth = widget.initialMonth ?? DateTime.now().month;
    yearController =
        TextEditingController(text: '${widget.initialYear ?? _defaultYear}');
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
                          _selectedMonth = monthNumber ?? 1;
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
        CancelButton(text: 'Cancel', onPressed: () => Navigator.pop(context)),
        SaveButton(
            text: 'Apply Filters',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                int year = int.tryParse(yearController.text) ?? _defaultYear;
                Navigator.pop(context, {"year": year, "month": _selectedMonth});
              }
            }),
      ],
    );
  }
}
