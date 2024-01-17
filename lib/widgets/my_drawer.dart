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
              decoration: BoxDecoration(
                color: Color.fromARGB(221, 0, 88, 71),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text(
              'Dashboard',
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
            leading: const Icon(Icons.pets_rounded),
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
            leading: const Icon(Icons.water),
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
            leading: const Icon(Icons.money),
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
            leading: const Icon(Icons.money),
            title: const Text('Milk Sales Payments'),
            selected: _selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              _onItemTapped(4);
              context.pushNamed("milk_sales_payments");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('Health Management'),
            selected: _selectedIndex == 5,
            onTap: () {
              // Update the state of the app
              _onItemTapped(5);
              context.pushNamed("healthManagement");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clients & Consumers'),
            selected: _selectedIndex == 6,
            onTap: () {
              // Update the state of the app
              _onItemTapped(6);
              context.pushNamed("clients_consumers");
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Expenses & Income'),
            selected: _selectedIndex == 7,
            onTap: () {
              // Update the state of the app
              _onItemTapped(7);
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
