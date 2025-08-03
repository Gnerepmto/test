class AppConstants {
  static const String appName = 'CashewConnect';
  static const String appVersion = '1.0.0';
  static const String companyName = 'CashewConnect Bénin';
  
  // Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String producerDashboardRoute = '/producer-dashboard';
  static const String investorDashboardRoute = '/investor-dashboard';
  static const String producerProfileRoute = '/producer-profile';
  static const String investorProfileRoute = '/investor-profile';
  static const String catalogRoute = '/catalog';
  static const String paymentRoute = '/payment';
  static const String chatRoute = '/chat';
  
  // User Types
  static const String producerType = 'producer';
  static const String investorType = 'investor';
  
  // Storage Keys
  static const String userTypeKey = 'user_type';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  
  // API Endpoints
  static const String baseUrl = 'https://api.cashewconnect.bj';
  static const String mtnMomoUrl = 'https://api.mtn.bj/collection';
  static const String moovMoneyUrl = 'https://api.moov-africa.bj';
  
  // Payment
  static const double minInvestmentAmount = 50000; // 50,000 FCFA
  static const double maxInvestmentAmount = 10000000; // 10,000,000 FCFA
  
  // App Limits
  static const int maxPhotosPerProject = 10;
  static const int maxProjectDescriptionLength = 1000;
  static const int chatMessageMaxLength = 500;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
}