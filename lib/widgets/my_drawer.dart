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
              context.pushNamed("dashboard");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Herd Management'),
            selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              _onItemTapped(2);
              context.pushNamed("herd_management");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Milk Production'),
            selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app
              _onItemTapped(2);
              context.pushNamed("milk_production");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Milk Sales & Consumption'),
            selected: _selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              _onItemTapped(3);
              context.pushNamed("milk_sales_consumption");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Health Management'),
            selected: _selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              _onItemTapped(4);
              context.pushNamed("health_management");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Clients & Consumers'),
            selected: _selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              _onItemTapped(5);
              context.pushNamed("clients_consumers");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Expenses & Income'),
            selected: _selectedIndex == 5,
            onTap: () {
              // Update the state of the app
              _onItemTapped(6);
              context.pushNamed("expenses_incomes");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
