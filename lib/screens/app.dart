import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/controllers/expense_controller.dart';
import 'package:DigitalDairy/controllers/income_controller.dart';
import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/controllers/milk_consumption_controller.dart';
import 'package:DigitalDairy/controllers/milk_production_controller.dart';
import 'package:DigitalDairy/controllers/milk_sale_controller.dart';
import 'package:DigitalDairy/screens/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_controller.dart';
import '../theme/theme.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MilkProductionController()),
            ChangeNotifierProvider(create: (_) => ClientController()),
            ChangeNotifierProvider(create: (_) => MilkConsumerController()),
            ChangeNotifierProvider(create: (_) => ExpenseController()),
            ChangeNotifierProvider(create: (_) => IncomeController()),
            ChangeNotifierProvider(create: (_) => MilkSaleController()),
            ChangeNotifierProvider(create: (_) => MilkConsumptionController()),
          ],
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.appRouter,
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',
              title: "Digital Dairy",
              // Define a light and dark color theme. Then, read the user's
              // preferred ThemeMode (light, dark, or system default) from the
              // SettingsController to display the correct theme.
              theme: myTheme,
              darkTheme: ThemeData.dark(),
              themeMode: settingsController.themeMode,
            );
          },
        );
      },
    );
  }
}
