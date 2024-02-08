import 'package:DigitalDairy/screens/clients/clients.dart';
import 'package:DigitalDairy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class ClientsTabView extends StatelessWidget {
  const ClientsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Clients",
              ),
            ],
          ),
          title: const Text('Clients'),
        ),
        body: const TabBarView(
          children: [
            ClientsScreen(),
          ],
        ),
      ),
    );
  }
}
