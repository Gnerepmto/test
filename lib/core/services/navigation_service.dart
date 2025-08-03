import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/producer/presentation/pages/producer_dashboard_page.dart';
import '../../features/investor/presentation/pages/investor_dashboard_page.dart';
import '../../features/producer/presentation/pages/producer_profile_page.dart';
import '../../features/investor/presentation/pages/investor_profile_page.dart';
import '../../features/producer/presentation/pages/catalog_page.dart';
import '../../features/payment/presentation/pages/payment_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.splashRoute,
    debugLogDiagnostics: true,
    routes: [
      // Authentification
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppConstants.onboardingRoute,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Producteurs
      GoRoute(
        path: AppConstants.producerDashboardRoute,
        name: 'producer-dashboard',
        builder: (context, state) => const ProducerDashboardPage(),
      ),
      GoRoute(
        path: AppConstants.producerProfileRoute,
        name: 'producer-profile',
        builder: (context, state) {
          final producerId = state.pathParameters['id'] ?? '';
          return ProducerProfilePage(producerId: producerId);
        },
      ),
      
      // Investisseurs
      GoRoute(
        path: AppConstants.investorDashboardRoute,
        name: 'investor-dashboard',
        builder: (context, state) => const InvestorDashboardPage(),
      ),
      GoRoute(
        path: AppConstants.investorProfileRoute,
        name: 'investor-profile',
        builder: (context, state) {
          final investorId = state.pathParameters['id'] ?? '';
          return InvestorProfilePage(investorId: investorId);
        },
      ),
      
      // Catalogue
      GoRoute(
        path: AppConstants.catalogRoute,
        name: 'catalog',
        builder: (context, state) => const CatalogPage(),
      ),
      
      // Paiements
      GoRoute(
        path: AppConstants.paymentRoute,
        name: 'payment',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId'] ?? '';
          final amount = double.tryParse(state.pathParameters['amount'] ?? '0') ?? 0;
          return PaymentPage(projectId: projectId, amount: amount);
        },
      ),
      
      // Chat
      GoRoute(
        path: AppConstants.chatRoute,
        name: 'chat',
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'] ?? '';
          return ChatPage(chatId: chatId);
        },
      ),
    ],
    
    // Gestion des erreurs de navigation
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Erreur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'La page que vous cherchez n\'existe pas.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.splashRoute),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Extensions utiles pour la navigation
extension NavigationExtension on BuildContext {
  void pushNamed(String routeName, {Map<String, String>? pathParameters}) {
    go(routeName, extra: pathParameters);
  }
  
  void pushReplacementNamed(String routeName, {Map<String, String>? pathParameters}) {
    pushReplacement(routeName, extra: pathParameters);
  }
  
  void popAndPushNamed(String routeName, {Map<String, String>? pathParameters}) {
    pop();
    pushNamed(routeName, pathParameters: pathParameters);
  }
}