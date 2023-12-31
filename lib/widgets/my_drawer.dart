import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/flutter_logo.png"),
              ),
              currentAccountPictureSize: Size(100, 200),
              accountName: Text(
                'Brian Muciri',
                style: TextStyle(fontSize: 24.0),
              ),
              accountEmail: Text('jane.doe@example.com'),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Dashboard',
              style: TextStyle(fontSize: 24.0),
            ),
            selected: _selectedIndex == 0,
            onTap: () {
              // Update the state of the app
              _onItemTapped(0);
              context.goNamed("home");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Daily Milk Production'),
            selected: _selectedIndex == 1,
            onTap: () {
              // Update the state of the app
              _onItemTapped(1);
              context.goNamed("dailyMilkProduction");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Herd'),
            selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              _onItemTapped(2);
              context.goNamed("cows");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Clients & Consumers'),
            selected: _selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              _onItemTapped(4);
              context.goNamed("clients_consumers");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Expenses & Income'),
            selected: _selectedIndex == 5,
            onTap: () {
              // Update the state of the app
              _onItemTapped(5);
              context.goNamed("expenses_incomes");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
