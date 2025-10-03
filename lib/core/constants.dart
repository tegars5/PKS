class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://wjsjyxcwanzxzmjctlye.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indqc2p5eGN3YW56eHptamN0bHllIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkzNjk0MzAsImV4cCI6MjA3NDk0NTQzMH0.zpPQRvhHEFxACopL0ifMnRtUSLn70MwBQigZdQnHaw0';
  
  // App Information
  static const String appName = 'PalmShell Tracker';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
  static const String tokenKey = 'auth_token';
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  // User Roles
  static const String roleBuyer = 'buyer';
  static const String roleSupplier = 'supplier';
  static const String roleDriver = 'driver';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderShipping = 'shipping';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
  
  // Article Categories
  static const String categoryNews = 'news';
  static const String categoryTraining = 'training';
  
  // Map Configuration
  static const double defaultMapZoom = 14.0;
  static const double detailMapZoom = 16.0;
  
  // API Endpoints
  static const String apiBaseUrl = 'https://api.palmshell-tracker.com';
  static const String apiVersion = 'v1';
}