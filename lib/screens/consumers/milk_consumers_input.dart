import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/my_default_text_field.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/snackbars.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:provider/provider.dart';

class MilkConsumerInputScreen extends StatefulWidget {
  const MilkConsumerInputScreen({super.key, this.editMilkConsumerId});
  final String? editMilkConsumerId;

  @override
  MilkConsumerFormState createState() {
    return MilkConsumerFormState();
  }
}

class MilkConsumerFormState extends State<MilkConsumerInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  MilkConsumer? _milkConsumerToEdit;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactsController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? editMilkConsumerId = widget.editMilkConsumerId;
    if (editMilkConsumerId != null) {
      final milkConsumersList =
          context.read<MilkConsumerController>().milkConsumersList;
      _milkConsumerToEdit = milkConsumersList
          .firstWhereOrNull((client) => client.getId == editMilkConsumerId);
      _firstNameController.value =
          TextEditingValue(text: _milkConsumerToEdit?.getFirstName ?? '');
      _lastNameController.value =
          TextEditingValue(text: _milkConsumerToEdit?.getLastName ?? '');
      _contactsController.value =
          TextEditingValue(text: _milkConsumerToEdit?.getContacts ?? '');
      _locationController.value =
          TextEditingValue(text: _milkConsumerToEdit?.getLocation ?? '');
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            editMilkConsumerId != null
                ? 'Edit Milk Consumer Details'
                : 'New Milk Consumer Details',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          inputFieldLabel(
                            context,
                            "First Name",
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name cannot be empty';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          inputFieldLabel(
                            context,
                            "Last Name",
                          ),
                          MyDefaultTextField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last name cannot be empty';
                              }
                              return null;
                            },
                          ),
                          inputFieldLabel(
                            context,
                            "Contacts",
                          ),
                          MyDefaultTextField(
                            controller: _contactsController,
                          ),
                          inputFieldLabel(
                            context,
                            "Location",
                          ),
                          MyDefaultTextField(
                            controller: _locationController,
                          ),
                        ],
                      )),
                  SaveButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String firstName = _firstNameController.text.trim();
                          String lastName = _lastNameController.text.trim();
                          String contacts = _contactsController.text.trim();
                          String location = _locationController.text.trim();

                          final newMilkConsumer = MilkConsumer();
                          newMilkConsumer.setFirstName = firstName;
                          newMilkConsumer.setLastName = lastName;
                          newMilkConsumer.setContacts = contacts;
                          newMilkConsumer.setLocation = location;

                          if (editMilkConsumerId != null) {
                            newMilkConsumer.setId = editMilkConsumerId;
                            //update the client in the db
                            await context
                                .read<MilkConsumerController>()
                                .editMilkConsumer(newMilkConsumer)
                                .then((value) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Consumer edited successfully!"));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the client in the db
                            await context
                                .read<MilkConsumerController>()
                                .addMilkConsumer(newMilkConsumer)
                                .then((value) {
                              //reset the form
                              _firstNameController.clear();
                              _lastNameController.clear();
                              _contactsController.clear();
                              _locationController.clear();
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              //show a snackbar showing the user that saving has been successful
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "MilkConsumer added successfully."));
                            }).catchError((error) {
                              //remove the loading dialog
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      text: "Save Details")
                ],
              )),
        )));
  }
}
