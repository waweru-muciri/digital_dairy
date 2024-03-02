import 'package:DigitalDairy/controllers/feeding_item_controller.dart';
import 'package:DigitalDairy/models/feeding_item.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedingItemInputScreen extends StatefulWidget {
  const FeedingItemInputScreen({super.key, this.editFeedingItemId});
  final String? editFeedingItemId;
  static const String addDetailsRoutePath = "/add_feeding_item_details";
  static const String editDetailsRoutePath =
      "/edit_feeding_item_details/:editFeedingItemId";

  @override
  FeedingItemFormState createState() {
    return FeedingItemFormState();
  }
}

class FeedingItemFormState extends State<FeedingItemInputScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _alertQuantityController =
      TextEditingController();
  final TextEditingController _currentQuantityController =
      TextEditingController();
  final TextEditingController _unitPriceController =
      TextEditingController(text: "0");
  FeedingItem? _feedingItemToEdit;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<FeedingItemFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _alertQuantityController.dispose();
    _currentQuantityController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editFeedingItemId = widget.editFeedingItemId;
    if (editFeedingItemId != null) {
      final feedingItemsList =
          context.read<FeedingItemController>().feedingItemsList;
      _feedingItemToEdit = feedingItemsList.firstWhereOrNull(
        (feedingItem) => feedingItem.getId == editFeedingItemId,
      );
      _alertQuantityController.value = TextEditingValue(
          text: _feedingItemToEdit?.getAlertQuantity.toString() ?? '');
      _itemNameController.value =
          TextEditingValue(text: _feedingItemToEdit?.getName ?? '');
      _currentQuantityController.value = TextEditingValue(
          text: _feedingItemToEdit?.getCurrentQuantity.toString() ?? '');
      _unitPriceController.value = TextEditingValue(
          text: _feedingItemToEdit?.getUnitPrice.toString() ?? '');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            editFeedingItemId != null
                ? 'Edit Feeding Item Details'
                : 'Add Feeding Item Details',
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          inputFieldLabel(
                            context,
                            "Name",
                          ),
                          MyDefaultTextField(
                            controller: _itemNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Item name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Current Quantity",
                          ),
                          MyDefaultTextField(
                            controller: _currentQuantityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Quantity cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Quantity must be a number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          inputFieldLabel(
                            context,
                            "Unit Price",
                          ),
                          MyDefaultTextField(
                            controller: _unitPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Unit price cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Unit price must be a number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                          inputFieldLabel(
                            context,
                            "Alert Quantity",
                          ),
                          MyDefaultTextField(
                            controller: _alertQuantityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alert quantity cannot be empty';
                              } else if (double.tryParse(value) == null) {
                                return "Alert quantity must be a number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      )),
                  SaveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String itemName = _itemNameController.text.trim();
                          double currentQuantity = double.parse(
                              _currentQuantityController.text.trim());
                          int alertQuantity =
                              int.parse(_alertQuantityController.text.trim());
                          double unitPrice =
                              double.parse(_unitPriceController.text);
                          //edit the properties as required
                          final newFeedingItem = FeedingItem();
                          newFeedingItem.setName = itemName;
                          newFeedingItem.setCurrentQuantity = currentQuantity;
                          newFeedingItem.setAlertQuantity = alertQuantity;
                          newFeedingItem.setUnitPrice = unitPrice;

                          if (editFeedingItemId != null) {
                            newFeedingItem.setId = editFeedingItemId;
                            //update the feedingItem in the db
                            await context
                                .read<FeedingItemController>()
                                .editFeedingItem(newFeedingItem)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Feeding Item edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the feedingItem in the db
                            await context
                                .read<FeedingItemController>()
                                .addFeedingItem(newFeedingItem)
                                .then((value) {
                              //reset the form
                              _itemNameController.clear();
                              _currentQuantityController.clear();
                              _unitPriceController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Feeding Item added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      text: "Save Feeding Item")
                ],
              )),
        )));
  }
}
