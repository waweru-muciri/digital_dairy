import 'package:DigitalDairy/controllers/cow_controller.dart';
import 'package:DigitalDairy/models/cow.dart';
import 'package:DigitalDairy/widgets/search_bar.dart';
import 'package:DigitalDairy/widgets/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    return Card(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      )),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: FilterInputField(
                            onQueryChanged:
                                context.read<CowController>().filterCows)),
                  ),
                  Expanded(
                      flex: 1, child: getFilterIconButton(onPressed: () {})),
                ],
              )),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Text(
                      "${_cowList.length} Cows Found",
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: () => context.pushNamed("addCowDetails"),
                    label: const Text("Add"),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: _cowList.length,
              itemBuilder: (context, index) {
                final cow = _cowList[index];
                bool cowActiveStatus = cow.getActiveStatus;
                final cowInitials = cow.getName.split(" ").fold('',
                    (previousValue, newValue) => previousValue + newValue[0]);
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
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
                              style: Theme.of(context).textTheme.bodyLarge)),
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
                              child:
                                  Text('Sire: ${cow.getSire?.getName ?? ''}')),
                          getActiveStatusChip(context, cowActiveStatus),
                        ],
                      )
                    ],
                  ),
                  onTap: () => context.pushNamed("cowDetails",
                      pathParameters: {"cowId": '${cow.getId}'}),
                );
              },
            ),
          ))
        ]),
      ),
    );
  }
}
