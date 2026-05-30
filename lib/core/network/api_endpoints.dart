class ApiEndpoints {
  ApiEndpoints._();

  /// Production API on Vercel (auth, services, news, addresses, orders, …).
  static const String baseUrl = 'https://revexa-backend.vercel.app/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static String resetPassword(String token) => '/auth/reset-password/$token';

  // Profile
  static const String profile = '/user/profile';
  static const String profileUpdate = '/user/profile/update';
  static const String deleteAccount = '/user/account';

  // Users (legacy)
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

  // Services
  static const String services = '/services';
  static String serviceById(String id) => '/services/$id';

  // Upload
  static const String upload = '/upload';

  // Addresses
  static const String addresses = '/addresses';

  // News — GET /news, POST /news/sync
  static const String news = '/news';
  static const String newsSync = '/news/sync';

  // Notifications
  static const String sendNotification = '/notifications/send';
}
