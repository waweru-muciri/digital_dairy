import 'package:DigitalDairy/controllers/client_controller.dart';
import 'package:DigitalDairy/controllers/milk_consumer_controller.dart';
import 'package:DigitalDairy/screens/clients.dart';
import 'package:DigitalDairy/screens/milk_consumers.dart';
import 'package:go_router/go_router.dart';
import 'package:DigitalDairy/screens/home_screen.dart';
import 'package:provider/provider.dart';
import "package:DigitalDairy/controllers/milk_production_controller.dart";
import 'package:DigitalDairy/screens/daily_milk_production.dart';
import 'package:DigitalDairy/screens/cow_details_screen.dart';
import "package:DigitalDairy/screens/cows.dart";
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class AppRouter {
// GoRouter configuration
  static final appRouter = GoRouter(
    routes: [
      GoRoute(
          name: "sign-in",
          path: '/sign-in',
          builder: (context, state) => const FirebaseSignInScreen()),
      GoRoute(
        name: "home",
        path: HomeScreen.routeName,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => MilkProductionController(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        name: "dailyMilkProduction",
        path: DailyMilkProductionScreen.routeName,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => MilkProductionController(),
          child: const DailyMilkProductionScreen(),
        ),
      ),
      GoRoute(
        name: "clients",
        path: ClientsScreen.routeName,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => ClientController(),
          child: const ClientsScreen(),
        ),
      ),
      GoRoute(
        name: "consumers",
        path: MilkConsumersScreen.routeName,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => MilkConsumerController(),
          child: const MilkConsumersScreen(),
        ),
      ),
      GoRoute(
          name: "cows",
          path: CowsScreen.routeName,
          builder: (context, state) => ChangeNotifierProvider(
                create: (_) => MilkProductionController(),
                child: CowsScreen(
                  activeStatus: state.uri.queryParameters["activeStatus"],
                  cowType: state.uri.queryParameters["cowType"],
                ),
              ),
          routes: [
            GoRoute(
              name: "cowDetailsScreen",
              path: CowDetailsScreen.routeName,
              builder: (context, state) => ChangeNotifierProvider(
                create: (_) => MilkProductionController(),
                child: CowDetailsScreen(cowId: state.pathParameters['cowId']),
              ),
            ),
          ]),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   return FirebaseAuth.instance.currentUser == null ? '/sign-in' : null;
    // }
  );
}

class FirebaseSignInScreen extends StatelessWidget {
  const FirebaseSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      showPasswordVisibilityToggle: true,
      providers: [EmailAuthProvider()],
      actions: [
        // AuthStateChangeAction<SignedIn>((context, state) {
        // }),
        AuthStateChangeAction((context, state) {
          final user = switch (state) {
            SignedIn(user: final user) => user,
            _ => null,
          };
          Navigator.pushReplacementNamed(context, '/home');
          print('Firebase logged in user, $user.toString()');
        }),
      ],
      subtitleBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'Please sign in to continue.',
          AuthAction.signUp => 'Please create an account to continue',
          _ => 'Invalid action: $action',
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Welcome to Digital Dairy! $actionText.'),
        );
      },
      footerBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'signing in',
          AuthAction.signUp => 'registering',
          _ => throw Exception('Invalid action: $action'),
        };
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'By $actionText, you agree to our terms and conditions.',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
