import 'package:DigitalDairy/screens/client_consumers/client_consumers_tabs.dart';
import 'package:DigitalDairy/screens/client_consumers/clients/client_input.dart';
import 'package:DigitalDairy/screens/client_consumers/consumers/milk_consumers_input.dart';
import 'package:DigitalDairy/screens/expenses_income_tabs/expenses/expense_input.dart';
import 'package:DigitalDairy/screens/expenses_income_tabs/expenses_income_tabs.dart';
import 'package:DigitalDairy/screens/health_management/diseases/disease_input.dart';
import 'package:DigitalDairy/screens/health_management/health_management_tabbed_view.dart';
import 'package:DigitalDairy/screens/health_management/treatments/treatment_input.dart';
import 'package:DigitalDairy/screens/health_management/vaccinations/vaccination_input.dart';
import 'package:DigitalDairy/screens/herd_management/cows.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_consumption/milk_consumption_input.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/milk_sale_input.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sales_consumption_tabs.dart';
import 'package:go_router/go_router.dart';
import 'package:DigitalDairy/screens/home_screen.dart';
import 'package:DigitalDairy/screens/milk_production/daily_milk_production.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:DigitalDairy/screens/expenses_income_tabs/income/income_input.dart';

class AppRouter {
// GoRouter configuration
  static final appRouter = GoRouter(
    routes: [
      GoRoute(
          name: "sign-in",
          path: '/sign-in',
          builder: (context, state) => const FirebaseSignInScreen()),
      //dashboard route
      GoRoute(
        name: "dashboard",
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      //main milk production route
      GoRoute(
        name: "milk_production",
        path: DailyMilkProductionScreen.routeName,
        builder: (context, state) => const DailyMilkProductionScreen(),
      ),
      //main herd management route
      GoRoute(
        name: "herd_management",
        path: CowsScreen.routeName,
        builder: (context, state) => const CowsScreen(),
      ),
      //main health management route
      GoRoute(
        name: "healthManagement",
        path: "/health_management",
        builder: (context, state) => const HealthManagementTabView(),
      ),
      //add & edit diseases routes
      GoRoute(
        name: "addDiseaseDetails",
        path: DiseaseInputScreen.addDetailsRouteName,
        builder: (context, state) => const DiseaseInputScreen(),
      ),
      GoRoute(
        name: "editDiseaseDetails",
        path: DiseaseInputScreen.editDetailsRouteName,
        builder: (context, state) => DiseaseInputScreen(
          editDiseaseId: state.pathParameters["editDiseaseId"],
        ),
      ),
      //add & edit vaccination routes
      GoRoute(
        name: "addVaccinationDetails",
        path: VaccinationInputScreen.addDetailsRouteName,
        builder: (context, state) => const VaccinationInputScreen(),
      ),
      GoRoute(
        name: "editVaccinationDetails",
        path: VaccinationInputScreen.editDetailsRouteName,
        builder: (context, state) => VaccinationInputScreen(
          editVaccinationId: state.pathParameters["editVaccinationId"],
        ),
      ),
      //add & edit treatment routes
      GoRoute(
        name: "addTreatmentDetails",
        path: TreatmentInputScreen.addDetailsRouteName,
        builder: (context, state) => const TreatmentInputScreen(),
      ),
      GoRoute(
        name: "editTreatmentDetails",
        path: TreatmentInputScreen.editDetailsRouteName,
        builder: (context, state) => TreatmentInputScreen(
          editTreatmentId: state.pathParameters["editTreatmentId"],
        ),
      ),
      //main clients & consumers tab view
      GoRoute(
        name: "clients_consumers",
        path: '/clients_consumers',
        builder: (context, state) => const ClientConsumersTabView(),
      ),
      //add & edit clients routes
      GoRoute(
        name: "addClientDetails",
        path: "/add_client_details",
        builder: (context, state) => const ClientInputScreen(),
      ),
      GoRoute(
        name: "editClientDetails",
        path: '/edit_client_details/:editClientId',
        builder: (context, state) => ClientInputScreen(
          editClientId: state.pathParameters["editClientId"],
        ),
      ),
      //add & edit milk consumers routes
      GoRoute(
        name: "addMilkConsumerDetails",
        path: "/add_consumer_details",
        builder: (context, state) => const MilkConsumerInputScreen(),
      ),
      GoRoute(
        name: "editMilkConsumerDetails",
        path: '/edit_consumer/:editMilkConsumerId',
        builder: (context, state) => MilkConsumerInputScreen(
          editMilkConsumerId: state.pathParameters["editMilkConsumerId"],
        ),
      ),
      //main expenses & income routes
      GoRoute(
        name: "expenses_incomes",
        path: '/expenses_incomes',
        builder: (context, state) => const ExpensesIncomesTabView(),
      ),
      //add & edit expenses routes
      GoRoute(
        name: "addExpenseDetails",
        path: "/add_expense_details",
        builder: (context, state) => const ExpenseInputScreen(),
      ),
      GoRoute(
        name: "editExpenseDetails",
        path: '/edit_expense_details/:editExpenseId',
        builder: (context, state) => ExpenseInputScreen(
          editExpenseId: state.pathParameters["editExpenseId"],
        ),
      ),
      //add & edit income routes
      GoRoute(
        name: "addIncomeDetails",
        path: "/add_income_details",
        builder: (context, state) => const IncomeInputScreen(),
      ),
      GoRoute(
        name: "editIncomeDetails",
        path: '/edit_income_details/:editIncomeId',
        builder: (context, state) => IncomeInputScreen(
          editIncomeId: state.pathParameters["editIncomeId"],
        ),
      ),
      //main milk sales and consumption tab view
      GoRoute(
        name: "milk_sales_consumption",
        path: '/milk_sales_consumption',
        builder: (context, state) => const MilkSalesConsumptionTabView(),
      ),
      //milk consumption routes
      GoRoute(
        name: "addMilkConsumptionDetails",
        path: MilkConsumptionInputScreen.addDetailsRouteName,
        builder: (context, state) => const MilkConsumptionInputScreen(),
      ),
      GoRoute(
        name: "editMilkConsumptionDetails",
        path: MilkConsumptionInputScreen.editDetailsRouteName,
        builder: (context, state) => MilkConsumptionInputScreen(
          editMilkConsumptionId: state.pathParameters["editMilkConsumptionId"],
        ),
      ),
      //milk sales routes
      GoRoute(
        name: "addMilkSaleDetails",
        path: MilkSaleInputScreen.addDetailsRouteName,
        builder: (context, state) => const MilkSaleInputScreen(),
      ),
      GoRoute(
        name: "editMilkSaleDetails",
        path: MilkSaleInputScreen.editDetailsRouteName,
        builder: (context, state) => MilkSaleInputScreen(
          editMilkSaleId: state.pathParameters["editMilkSaleId"],
        ),
      ),
      //   GoRoute(
      //       name: "cows",
      //       path: CowsScreen.routeName,
      //       builder: (context, state) => ChangeNotifierProvider(
      //             create: (_) => MilkProductionController(),
      //             child: CowsScreen(
      //               activeStatus: state.uri.queryParameters["activeStatus"],
      //               cowType: state.uri.queryParameters["cowType"],
      //             ),
      //           ),
      //       routes: [
      //         GoRoute(
      //           name: "cowDetailsScreen",
      //           path: CowDetailsScreen.routeName,
      //           builder: (context, state) => ChangeNotifierProvider(
      //             create: (_) => MilkProductionController(),
      //             child: CowDetailsScreen(cowId: state.pathParameters['cowId']),
      //           ),
      //         ),
      //       ]),
    ],
    // // redirect: (BuildContext context, GoRouterState state) {
    // //   return FirebaseAuth.instance.currentUser == null ? '/sign-in' : null;
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
          debugPrint('Firebase logged in user, $user.toString()');
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
