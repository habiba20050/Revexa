class ApiEndpoints {
  ApiEndpoints._();

  /// Production API on Vercel (auth, services, news, addresses, orders, …).
  static const String baseUrl = 'https://revexa-backend.vercel.app/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-reset-code';
  static const String resetPassword = '/auth/reset-password';

  // Profile — Swagger: /users/{userId} with userId = "me"
  static const String profile = '/users/me';
  static const String profileUpdate = '/users/me';
  static const String deleteAccount = '/users/me';

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

  // NOTE: There is NO /services endpoint on the Revexa backend.
  // Swagger confirms it does not exist — calling it returns 404.
  // The service catalogue is served via /products (see above).
  // Do NOT add /services back here.

  // Upload & Media — PATCH /users/avatar (field: image), POST /upload (field: images[])
  static const String avatarUpload = '/users/avatar';
  static const String upload = '/upload';

  // Addresses — works on production (undocumented in Swagger)
  static const String addresses = '/addresses';

  // News — GET /news, POST /news/sync
  static const String news = '/news';
  static const String newsSync = '/news/sync';

  // Auth extensions (not wired in UI yet)
  static const String googleAuth = '/auth/google';
  static const String fcmToken = '/users/fcm-token';
}
