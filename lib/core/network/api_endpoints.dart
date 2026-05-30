import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google-login';
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

  // Services
  static const String services = '/services';
  static String serviceById(String id) => '/services/$id';

  // Upload
  static const String upload = '/upload';

  // Addresses
  static const String addresses = '/addresses';

  // News
  static const String news = '/news';

  // Notifications
  static const String sendNotification = '/notifications/send';
}
