import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';

/// Resolves a booking target id to a valid MongoDB id from products or services API.
class OrderIdResolver {
  OrderIdResolver._();

  static final _objectIdPattern = RegExp(r'^[a-fA-F0-9]{24}$');

  static bool isValidObjectId(String id) => _objectIdPattern.hasMatch(id);

  static Future<String> resolve({
    required String fallbackId,
    required String serviceName,
  }) async {
    if (isValidObjectId(fallbackId)) return fallbackId;

    final dio = DioClient.instance.dio;
    final nameLower = serviceName.toLowerCase();

    // Try products (orders route often uses product id)
    try {
      final productsRes = await dio.get(ApiEndpoints.products);
      final products = _extractList(productsRes.data);
      final match = _findByName(products, nameLower);
      if (match != null) return match;
      if (products.isNotEmpty) {
        final firstId = _readId(products.first);
        if (firstId != null) return firstId;
      }
    } catch (_) {}

    // Try services
    try {
      final servicesRes = await dio.get(ApiEndpoints.services);
      final services = _extractList(servicesRes.data);
      final match = _findByName(services, nameLower);
      if (match != null) return match;
    } catch (_) {}

    throw Exception(
      'Could not find "$serviceName" on the server. '
      'Add it in the admin panel or pick a service from the API list.',
    );
  }

  static List<Map<String, dynamic>> _extractList(dynamic body) {
    if (body is List) {
      return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    if (body is Map && body['data'] is List) {
      return (body['data'] as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return [];
  }

  static String? _findByName(List<Map<String, dynamic>> items, String nameLower) {
    for (final item in items) {
      final title = (item['title'] ?? item['name'] ?? '').toString().toLowerCase();
      if (title.contains(nameLower) || nameLower.contains(title)) {
        return _readId(item);
      }
    }
    return null;
  }

  static String? _readId(Map<String, dynamic> json) {
    final id = json['_id']?.toString() ?? json['id']?.toString();
    if (id != null && id.isNotEmpty) return id;
    return null;
  }
}
