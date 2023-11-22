import 'package:digital_dairy/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

import '../sample_feature/sample_item_details_view.dart';
import '../sample_feature/sample_item_list_view.dart';
import '../controllers/settings_controller.dart';
import 'settings_view.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

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
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            title: "Digital Dairy",
            // onGenerateTitle: (BuildContext context) =>
            //     AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: themeData,
            darkTheme: ThemeData.light(),
            themeMode: settingsController.themeMode,
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? '/sign-in'
                : '/home',
            routes: {
              '/sign-in': (context) {
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
                      AuthAction.signUp =>
                        'Please create an account to continue',
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
              },
              '/home': (context) {
                return SettingsView(controller: settingsController);
              },
              SampleItemDetailsView.routeName: (context) {
                return const SampleItemDetailsView();
              },
              SampleItemListView.routeName: (context) {
                return const SampleItemListView();
              }
            }

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            // onGenerateRoute: (RouteSettings routeSettings) {
            //   return MaterialPageRoute<void>(
            //     settings: routeSettings,
            //     builder: (BuildContext context) {
            //       switch (routeSettings.name) {
            //         case SettingsView.routeName:
            //           return SettingsView(controller: settingsController);
            //         case SampleItemDetailsView.routeName:
            //           return const SampleItemDetailsView();
            //         case SampleItemListView.routeName:
            //         default:
            //           return const SampleItemListView();
            //       }
            //     },
            //   );
            // },
            );
      },
    );
  }
}
