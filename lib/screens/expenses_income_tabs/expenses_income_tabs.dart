import 'package:DigitalDairy/screens/client_consumers/clients/clients.dart';
import 'package:DigitalDairy/screens/client_consumers/consumers/milk_consumers.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class ClientConsumersTabs extends StatelessWidget {
  const ClientConsumersTabs({super.key, required this.initialTab});
  final String initialTab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Clients",
              ),
              Tab(
                text: "Consumers",
              ),
            ],
          ),
          title: const Text('Clients & Consumers'),
        ),
        body: const TabBarView(
          children: [
            ClientsScreen(),
            MilkConsumersScreen(),
          ],
        ),
      ),
    );
  }
}
