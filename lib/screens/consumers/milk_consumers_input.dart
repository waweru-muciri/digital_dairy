import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/models/milk_consumer.dart';
import 'package:DigitalDairy/widgets/error_snackbar.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
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
  // not a GlobalKey<ConsumerFormState>.
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
      final clientsList =
          context.read<MilkConsumerController>().milkConsumersList;
      final matchingConsumersList =
          clientsList.where((client) => client.id == editMilkConsumerId);
      if (matchingConsumersList.isNotEmpty) {
        milkConsumerDetails = matchingConsumersList.first;
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
                ? 'Edit Consumer Details'
                : 'Add Consumer Details',
          ),
        ),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name cannot be empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First Name',
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
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
                                  labelText: 'Last Name',
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
                              child: TextFormField(
                                controller: _contactsController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Consumer Contacts',
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 20, 0, 0),
                              child: TextFormField(
                                controller: _locationController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Consumer Location',
                                ),
                              )),
                        ],
                      )),
                  OutlinedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          String firstName = _firstNameController.text.trim();
                          String lastName = _lastNameController.text.trim();
                          String contacts = _contactsController.text.trim();
                          String location = _locationController.text.trim();

                          final MilkConsumer newConsumer = MilkConsumer(
                              firstName: firstName,
                              lastName: lastName,
                              contacts: contacts,
                              location: location,
                              id: editMilkConsumerId);
                          if (editMilkConsumerId != null) {
                            //update the client in the db
                            await context
                                .read<MilkConsumerController>()
                                .editMilkConsumer(newConsumer)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Consumer added successfully."));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          } else {
                            //add the client in the db
                            await context
                                .read<MilkConsumerController>()
                                .addMilkConsumer(newConsumer)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  successSnackBar(
                                      "Consumer added successfully."));
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  errorSnackBar("Saving failed!"));
                            });
                          }
                        }
                      },
                      child: const Text("Save"))
                ],
              )),
        )));
  }
}
