import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/widgets/buttons.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CowDetailsScreen extends StatefulWidget {
  const CowDetailsScreen({super.key, required this.cowId});

  final String cowId;
  static const routePath = '/cow/:cowId';

  @override
  State<StatefulWidget> createState() => CowDetailsScreenState();
}

class CowDetailsScreenState extends State<CowDetailsScreen> {
  late Cow cow;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String cowId = widget.cowId;
    cow = context
        .read<CowController>()
        .cowsList
        .firstWhere((cow) => cow.getId == cowId);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cow Details',
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                SizedBox(
                    height: 300,
                    child: Image.asset(
                      "assets/images/cowImage.jpg",
                      fit: BoxFit.fitHeight,
                      errorBuilder: (context, object, stackTrace) {
                        return const Center(
                          child: Text("Could not load image!"),
                        );
                      },
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  "Code: ${cow.getCowCode} Name: ${cow.getName}"),
                            )),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: getActiveStatusChip(
                                        context, cow.getActiveStatus))),
                          ],
                        ),
                      ),
                    ))
              ]),
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    getInfoRow("Dam", cow.getDam?.getName ?? ''),
                    getInfoRow("Sire", cow.getSire?.getName ?? ''),
                    getInfoRow("Type", cow.getCowType ?? ''),
                    getInfoRow("KSB Number", cow.getKSBNumber ?? ''),
                    getInfoRow("Breed", cow.getBreed ?? ''),
                    getInfoRow("Date of Birth", cow.getDateOfBirth ?? ''),
                    getInfoRow("Age", cow.getAge()),
                    getInfoRow("Weight At Birth",
                        cow.getBirthWeight?.toString() ?? ''),
                    getInfoRow("Color", cow.getColor ?? ''),
                    getInfoRow("Grade", cow.getGrade ?? ''),
                    getInfoRow("Date Purchased", cow.getDatePurchased ?? ''),
                    getInfoRow("Source", cow.getSource ?? ''),
                  ],
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DeleteButton(
                        onPressed: () async {
                          deleteFunc() async {
                            return await context
                                .read<CowController>()
                                .deleteCow(cow);
                          }

                          await showDeleteItemDialog(context, deleteFunc);
                        },
                      ),
                      SaveButton(
                          onPressed: () => context.pushNamed("editCowDetails",
                              pathParameters: {"editCowId": '${cow.getId}'}),
                          text: "Edit Details")
                    ],
                  ))
            ],
          ),
        ));
  }

  Widget getInfoRow(String titleText, String dataText) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(titleText))),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(10), child: Text(dataText)),
              )
            ],
          ),
        ),
        const Divider()
      ],
    );
  }
}
