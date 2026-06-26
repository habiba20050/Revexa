import 'package:revexa/core/network/api_endpoints.dart';

class ImageUrlUtils {
  ImageUrlUtils._();

  static const String assetPrefix = 'assets/';
  static final String _origin = ApiEndpoints.baseUrl.replaceAll('/api', '');

  static String? extract(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map) {
      return extract(raw['url'] ?? raw['secure_url'] ?? raw['image']);
    }
    if (raw is List && raw.isNotEmpty) {
      return extract(raw.first);
    }
    final value = raw.toString().trim();
    if (value.isEmpty || _looksMalformed(value)) return null;
    return value;
  }

  static String? resolve(dynamic raw) {
    final value = extract(raw);
    if (value == null || value.isEmpty) return null;
    if (isAsset(value)) return value;
    if (isNetwork(value)) return value;
    if (value.startsWith('//')) return 'https:$value';
    if (value.startsWith('/')) return '$_origin$value';
    return '$_origin/$value';
  }

  static bool isNetwork(String? url) {
    if (url == null || url.isEmpty) return false;
    final value = url.trim();
    if (_looksMalformed(value) || isAsset(value)) return false;
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return false;
    }
    final uri = Uri.tryParse(value);
    return uri != null && uri.host.isNotEmpty;
  }

  static bool isAsset(String? url) =>
      url != null && url.trim().startsWith(assetPrefix);

  static bool _looksMalformed(String value) {
    return value.contains('{') ||
        value.contains('}') ||
        value.startsWith('[') ||
        value.contains('Instance of');
  }
}
