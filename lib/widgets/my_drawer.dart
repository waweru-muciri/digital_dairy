import 'package:DigitalDairy/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = context.watch<SettingsController>().selectedIndex;
    return Drawer(
      // New a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/computerguy.jpg"),
              ),
              accountName: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Welcome Brian Muciri!',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  )),
              accountEmail: null,
            ),
          ),
          ListTile(
            title: const Text(
              'Home',
            ),
            selected: selectedIndex == 0,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(0);
              context.pushNamed("home");
              //close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Milk Production'),
            selected: selectedIndex == 1,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(1);
              context.pushNamed("milk_production");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Milk Sales & Consumption'),
            selected: selectedIndex == 2,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(2);
              context.pushNamed("milk_sales_consumption");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Clients'),
            selected: selectedIndex == 3,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(3);
              context.pushNamed("clients");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Consumers'),
            selected: selectedIndex == 4,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(4);
              context.pushNamed("milk_consumers");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Herd Management'),
            selected: selectedIndex == 5,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(5);
              context.pushNamed("herd_management");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Breeding'),
            selected: selectedIndex == 6,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(6);
              context.pushNamed("breeding_management");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Health Management'),
            selected: selectedIndex == 7,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(7);
              context.pushNamed("healthManagement");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Expenses & Income'),
            selected: selectedIndex == 8,
            onTap: () {
              context.read<SettingsController>().setSelectedIndex(8);
              context.pushNamed("expenses_incomes");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
