import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';

/// Resolves a booking target id to a valid MongoDB id from the products API.
///
/// NOTE: There is no /services endpoint on the Revexa backend (returns 404).
/// All catalogue lookups go through /products.
class OrderIdResolver {
  OrderIdResolver._();

  static final _objectIdPattern = RegExp(r'^[a-fA-F0-9]{24}$');

  static bool isValidObjectId(String id) => _objectIdPattern.hasMatch(id);

  static Future<String> resolve({
    required String fallbackId,
    required String serviceName,
  }) async {
    // If the caller already has a valid MongoDB ObjectId, use it directly.
    if (isValidObjectId(fallbackId)) return fallbackId;

    final dio = DioClient.instance.dio;
    final nameLower = serviceName.toLowerCase();

    // Search /products — the only catalogue endpoint on the backend.
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

    throw Exception(
      'Could not find "$serviceName" on the server. '
      'Add it in the admin panel or pick a service from the API list.',
    );
  }

  static List<Map<String, dynamic>> _extractList(dynamic body) {
    if (body is List) {
      return body.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    if (body is Map) {
      final data = body['data'];
      if (data is List) {
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      final products = body['products'];
      if (products is List) {
        return products.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    }
    return [];
  }

  static String? _findByName(List<Map<String, dynamic>> items, String nameLower) {
    // 1. Try exact or direct substring match
    for (final item in items) {
      final title =
          (item['title'] ?? item['name'] ?? '').toString().toLowerCase();
      if (title.contains(nameLower) || nameLower.contains(title)) {
        return _readId(item);
      }
    }

    // 2. Token overlap check: split search term into words and ensure they all exist in target title
    final searchWords = nameLower.split(RegExp(r'\s+')).where((w) => w.length > 2).toList();
    if (searchWords.isNotEmpty) {
      for (final item in items) {
        final title =
            (item['title'] ?? item['name'] ?? '').toString().toLowerCase();
        if (searchWords.every((word) => title.contains(word))) {
          return _readId(item);
        }
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
