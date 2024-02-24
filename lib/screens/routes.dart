import 'package:DigitalDairy/controllers/year_milk_production_controller.dart';
import 'package:DigitalDairy/screens/breeding_management/abortions_miscarriages/abortion_miscarriage_input.dart';
import 'package:DigitalDairy/screens/breeding_management/breeding_management_tab_view.dart';
import 'package:DigitalDairy/screens/breeding_management/pregnancy_diagnosis/pregnancy_diagnosis_input.dart';
import 'package:DigitalDairy/screens/clients/clients.dart';
import 'package:DigitalDairy/screens/clients/clients_sales_statements.dart';
import 'package:DigitalDairy/screens/clients/client_input.dart';
import 'package:DigitalDairy/screens/consumers/milk_consumers.dart';
import 'package:DigitalDairy/screens/consumers/milk_consumers_input.dart';
import 'package:DigitalDairy/screens/consumers/milk_consumers_statements.dart';
import 'package:DigitalDairy/screens/expenses_incomes/expenses/expense_input.dart';
import 'package:DigitalDairy/screens/expenses_incomes/expenses_income_tabs.dart';
import 'package:DigitalDairy/screens/health_management/diseases/disease_input.dart';
import 'package:DigitalDairy/screens/health_management/health_management_tabbed_view.dart';
import 'package:DigitalDairy/screens/health_management/treatments/treatment_input.dart';
import 'package:DigitalDairy/screens/health_management/vaccinations/vaccination_input.dart';
import 'package:DigitalDairy/screens/herd_management/cow-sales/cow_sale_input.dart';
import 'package:DigitalDairy/screens/herd_management/cows/cow_details_screen.dart';
import 'package:DigitalDairy/screens/herd_management/cows/cow_input.dart';
import 'package:DigitalDairy/screens/herd_management/herd_management_tabbed_view.dart';
import 'package:DigitalDairy/screens/breeding_management/semen/semen_catalog_input.dart';
import 'package:DigitalDairy/screens/milk_production/daily_milk_production_input.dart';
import 'package:DigitalDairy/screens/milk_production/milk_production_tabbed_view.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_consumption/milk_consumption_input.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sale/milk_sale_input.dart';
import 'package:DigitalDairy/screens/milk_sales_and_consumption/milk_sales_consumption_tabs.dart';
import 'package:DigitalDairy/screens/milk_sales_payments/milk_sale_payment_input.dart';
import 'package:go_router/go_router.dart';
import 'package:DigitalDairy/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:DigitalDairy/screens/expenses_incomes/income/income_input.dart';
import 'package:provider/provider.dart';

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
        path: HomeScreen.routePath,
        builder: (context, state) {
          return ChangeNotifierProvider(
              create: (context) => YearMilkProductionController(),
              child: const HomeScreen());
        },
      ),
      //clients route
      GoRoute(
        name: "clients",
        path: "/clients",
        builder: (context, state) => const ClientsScreen(),
      ),
      GoRoute(
        name: "clients_statements",
        path: ClientsMilkSalesStatementsScreen.routePath,
        builder: (context, state) => ClientsMilkSalesStatementsScreen(
          clientId: state.pathParameters["clientId"] ?? '',
        ),
      ),
      //consumers route
      GoRoute(
        name: "milk_consumers",
        path: "/milk_consumers",
        builder: (context, state) => const MilkConsumersScreen(),
      ),
      GoRoute(
        name: "milk_consumers_statements",
        path: MilkConsumersStatementsScreen.routePath,
        builder: (context, state) => MilkConsumersStatementsScreen(
          milkConsumerId: state.pathParameters["milkConsumerId"] ?? '',
        ),
      ),
      //main milk production route
      GoRoute(
        name: "milk_production",
        path: MilkProductionTabView.routePath,
        builder: (context, state) => const MilkProductionTabView(),
      ),
      //add milk sales payments route
      GoRoute(
        name: "addMilkSalePaymentDetails",
        path: MilkSalePaymentInputScreen.addDetailsRoutePath,
        builder: (context, state) => MilkSalePaymentInputScreen(
          milkSaleId: state.pathParameters["milkSaleId"],
        ),
      ),
      // //edit milk sales payments route
      // GoRoute(
      //   name: "editMilkSalePaymentDetails",
      //   path: MilkSalePaymentInputScreen.editDetailsRoutePath,
      //   builder: (context, state) => MilkSalePaymentInputScreen(
      //     editMilkSalePaymentId: state.pathParameters["editMilkSalePaymentId"],
      //   ),
      // ),
      //add & edit daily milk production routes
      GoRoute(
        name: "addDailyMilkProductionDetails",
        path: DailyMilkProductionInputScreen.addDetailsRoutePath,
        builder: (context, state) => const DailyMilkProductionInputScreen(),
      ),
      //add & edit diseases routes
      GoRoute(
        name: "editDailyMilkProductionDetails",
        path: DailyMilkProductionInputScreen.editDetailsRoutePath,
        builder: (context, state) => DailyMilkProductionInputScreen(
          editDailyMilkProductionId:
              state.pathParameters["editDailyMilkProductionId"],
        ),
      ),
      //breeding management routes
      GoRoute(
        name: "breeding_management",
        path: BreedingManagementTabView.routePath,
        builder: (context, state) => const BreedingManagementTabView(),
      ),
      //add pregnancy diagnosis route
      GoRoute(
        name: "addPregnancyDiagnosisDetails",
        path: PregnancyDiagnosisInputScreen.addDetailsRoutePath,
        builder: (context, state) => const PregnancyDiagnosisInputScreen(),
      ),
      //edit diseases routes
      GoRoute(
        name: "editPregnancyDiagnosisDetails",
        path: PregnancyDiagnosisInputScreen.editDetailsRoutePath,
        builder: (context, state) => PregnancyDiagnosisInputScreen(
          editPregnancyDiagnosisId:
              state.pathParameters["editPregnancyDiagnosisId"],
        ),
      ),
      //add abortion or miscarriage route
      GoRoute(
        name: "addAbortionMiscarriageDetails",
        path: AbortionMiscarriageInputScreen.addDetailsRoutePath,
        builder: (context, state) => const AbortionMiscarriageInputScreen(),
      ),
      //edit diseases routes
      GoRoute(
        name: "editAbortionMiscarriageDetails",
        path: AbortionMiscarriageInputScreen.editDetailsRoutePath,
        builder: (context, state) => AbortionMiscarriageInputScreen(
          editAbortionMiscarriageId:
              state.pathParameters["editAbortionMiscarriageId"],
        ),
      ),
      //main herd management route
      GoRoute(
        name: "herd_management",
        path: HerdManagementTabView.routePath,
        builder: (context, state) => const HerdManagementTabView(),
      ),
      GoRoute(
        name: "cowDetails",
        path: CowDetailsScreen.routePath,
        builder: (context, state) => CowDetailsScreen(
          cowId: state.pathParameters["cowId"] ?? '',
        ),
      ),
      GoRoute(
        name: "addCowDetails",
        path: CowInputScreen.addDetailsRoutePath,
        builder: (context, state) => const CowInputScreen(),
      ),
      //edit diseases routes
      GoRoute(
        name: "editCowDetails",
        path: CowInputScreen.editDetailsRoutePath,
        builder: (context, state) => CowInputScreen(
          editCowId: state.pathParameters["editCowId"],
        ),
      ),
      //add & edit semen catalog routes
      GoRoute(
        name: "addSemenCatalogDetails",
        path: SemenCatalogInputScreen.addDetailsRoutePath,
        builder: (context, state) => const SemenCatalogInputScreen(),
      ),
      //edit diseases routes
      GoRoute(
        name: "editSemenCatalogDetails",
        path: SemenCatalogInputScreen.editDetailsRoutePath,
        builder: (context, state) => SemenCatalogInputScreen(
          editSemenCatalogId: state.pathParameters["editSemenCatalogId"],
        ),
      ),
      //add & edit cow sales routes
      GoRoute(
        name: "addCowSaleDetails",
        path: CowSaleInputScreen.addDetailsRoutePath,
        builder: (context, state) => const CowSaleInputScreen(),
      ),
      //edit diseases routes
      GoRoute(
        name: "editCowSaleDetails",
        path: CowSaleInputScreen.editDetailsRoutePath,
        builder: (context, state) => CowSaleInputScreen(
          editCowSaleId: state.pathParameters["editCowSaleId"],
        ),
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
        path: DiseaseInputScreen.addDetailsRoutePath,
        builder: (context, state) => const DiseaseInputScreen(),
      ),
      GoRoute(
        name: "editDiseaseDetails",
        path: DiseaseInputScreen.editDetailsRoutePath,
        builder: (context, state) => DiseaseInputScreen(
          editDiseaseId: state.pathParameters["editDiseaseId"],
        ),
      ),
      //add & edit vaccination routes
      GoRoute(
        name: "addVaccinationDetails",
        path: VaccinationInputScreen.addDetailsRoutePath,
        builder: (context, state) => const VaccinationInputScreen(),
      ),
      GoRoute(
        name: "editVaccinationDetails",
        path: VaccinationInputScreen.editDetailsRoutePath,
        builder: (context, state) => VaccinationInputScreen(
          editVaccinationId: state.pathParameters["editVaccinationId"],
        ),
      ),
      //add & edit treatment routes
      GoRoute(
        name: "addTreatmentDetails",
        path: TreatmentInputScreen.addDetailsRoutePath,
        builder: (context, state) => const TreatmentInputScreen(),
      ),
      GoRoute(
        name: "editTreatmentDetails",
        path: TreatmentInputScreen.editDetailsRoutePath,
        builder: (context, state) => TreatmentInputScreen(
          editTreatmentId: state.pathParameters["editTreatmentId"],
        ),
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
        path: MilkConsumptionInputScreen.addDetailsRoutePath,
        builder: (context, state) => const MilkConsumptionInputScreen(),
      ),
      GoRoute(
        name: "editMilkConsumptionDetails",
        path: MilkConsumptionInputScreen.editDetailsRoutePath,
        builder: (context, state) => MilkConsumptionInputScreen(
          editMilkConsumptionId: state.pathParameters["editMilkConsumptionId"],
        ),
      ),
      //milk sales routes
      GoRoute(
        name: "addMilkSaleDetails",
        path: MilkSaleInputScreen.addDetailsRoutePath,
        builder: (context, state) => const MilkSaleInputScreen(),
      ),
      GoRoute(
        name: "editMilkSaleDetails",
        path: MilkSaleInputScreen.editDetailsRoutePath,
        builder: (context, state) => MilkSaleInputScreen(
          editMilkSaleId: state.pathParameters["editMilkSaleId"],
        ),
      ),
      //   GoRoute(
      //       name: "cows",
      //       path: CowsScreen.routePath,
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
      //           path: CowDetailsScreen.routePath,
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
