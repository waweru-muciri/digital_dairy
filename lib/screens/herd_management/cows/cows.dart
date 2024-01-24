import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CowsScreen extends StatefulWidget {
  const CowsScreen({super.key});
  static const routePath = '/cows';

  @override
  State<StatefulWidget> createState() => CowsScreenState();
}

class CowsScreenState extends State<CowsScreen> {
  late List<Cow> _cowList;
  final TextEditingController _getCowNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CowController>().getCows());
  }

  @override
  void dispose() {
    _getCowNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cowList = context.watch<CowController>().cowsList;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Card(
            child: Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: FilterInputField(
                                onQueryChanged:
                                    context.read<CowController>().filterCows)),
                      ],
                    )))),
        Expanded(
            child: Card(
                margin: const EdgeInsets.only(top: 10),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: _cowList.length * 10,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    final cow = _cowList[0];
                    bool cowActiveStatus = cow.getActiveStatus;
                    final cowInitials = cow.getName.split(" ").fold(
                        '',
                        (previousValue, newValue) =>
                            previousValue + newValue[0]);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 14),
                      isThreeLine: true,
                      titleAlignment: ListTileTitleAlignment.center,
                      dense: false,
                      trailing: null,
                      leading: CircleAvatar(
                        child: Text(cowInitials),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                              child: Text('Name: ${cow.getName}',
                                  style:
                                      Theme.of(context).textTheme.bodyLarge)),
                          Text(cow.getAge())
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Dam: ${cow.getDam?.getName ?? ''} ",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                      'Sire: ${cow.getSire?.getName ?? ''}')),
                              Chip(
                                  backgroundColor: Colors.white10,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  side: ChipTheme.of(context)
                                      .copyWith(
                                          side: BorderSide(
                                              color: cowActiveStatus
                                                  ? Colors.tealAccent
                                                      .withOpacity(0.3)
                                                  : Colors.redAccent
                                                      .withOpacity(0.3)))
                                      .side,
                                  labelPadding: const EdgeInsets.all(0),
                                  label: Text(
                                    cowActiveStatus ? "Active" : "Inactive",
                                  )),
                            ],
                          )
                        ],
                      ),
                      onTap: () {},
                    );
                  },
                ))),
      ]),
    );
  }
}
