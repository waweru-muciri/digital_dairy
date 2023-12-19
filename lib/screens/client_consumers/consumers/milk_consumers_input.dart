import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:provider/provider.dart';

// Create a Form widget.
class MilkConsumerInputScreen extends StatefulWidget {
  const MilkConsumerInputScreen({super.key, this.editMilkConsumerId});
  final String? editMilkConsumerId;

  @override
  MilkConsumerFormState createState() {
    return MilkConsumerFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MilkConsumerFormState extends State<MilkConsumerInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contactsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  late MilkConsumer? milkConsumerDetails;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MilkConsumerFormState>.
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
      final matchingMilkConsumersList =
      milkConsumersList.where((client) => client.id == editMilkConsumerId);
      if (matchingMilkConsumersList.isNotEmpty) {
        milkConsumerDetails = matchingMilkConsumersList.first;
        if (milkConsumerDetails != null) {
          _firstNameController.value =
              TextEditingValue(text: milkConsumerDetails!.firstName);
          _lastNameController.value =
              TextEditingValue(text: milkConsumerDetails!.lastName);
          _contactsController.value =
              TextEditingValue(text: milkConsumerDetails!.contacts);
          _locationController.value =
              TextEditingValue(text: milkConsumerDetails!.location);
        }
      }
    }
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text(
        editMilkConsumerId != null
        ? 'Edit Milk Consumer Details'
            : 'Add Milk Consumer Details',
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
                          // Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), child: Text(
                          //   editMilkConsumerId != null
                          //       ? 'Edit Milk Consumer Details'
                          //       : 'Add Milk Consumer Details',
                          //   textAlign: TextAlign.left,
                          //   style: Theme.of(context).textTheme.titleLarge,
                          // ),),
                          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text(
                            "First Name",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),),
                          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child: TextFormField(
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
                          ),),
                          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text(
                            "Last Name",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last name cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text(
                            "Contacts",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _contactsController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )),
                          Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text(
                            "Location",
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 10, 0, 10),
                              child: TextFormField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )),
                        ],
                      )),
                  OutlinedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          //show a loading dialog to the user while we save the info
                          showLoadingDialog(context);
                          String firstName = _firstNameController.text.trim();
                          String lastName = _lastNameController.text.trim();
                          String contacts = _contactsController.text.trim();
                          String location = _locationController.text.trim();

                          final MilkConsumer newMilkConsumer = MilkConsumer(
                              firstName: firstName,
                              lastName: lastName,
                              contacts: contacts,
                              location: location,
                              id: editMilkConsumerId);
                          if (editMilkConsumerId != null) {
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
                      child: const Text("Save Details"))
                ],
              )),
        )));
  }
}
