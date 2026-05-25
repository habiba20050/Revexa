class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://revexa-backend.vercel.app/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static String resetPassword(String token) => '/auth/reset-password/$token';

  // Users
  static const String users = '/users';
  static String userById(String id) => '/users/$id';

  // Products
  static const String products = '/products';
  static String productById(String id) => '/products/$id';

  // Orders
  static const String orders = '/orders';
  static String createOrder(String productId) => '/orders/$productId';
  static String orderById(String id) => '/orders/$id';

  // Categories
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';

  // Notifications
  static const String sendNotification = '/notifications/send';
}
