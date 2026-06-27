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

  static String avatarCacheBuster = DateTime.now().millisecondsSinceEpoch.toString();

  static String? resolve(dynamic raw) {
    final value = extract(raw);
    if (value == null || value.isEmpty) return null;
    
    String resolved;
    if (isAsset(value)) {
      resolved = value;
    } else if (isNetwork(value)) {
      resolved = value;
    } else if (value.startsWith('//')) {
      resolved = 'https:$value';
    } else if (value.startsWith('/')) {
      resolved = '$_origin$value';
    } else {
      resolved = '$_origin/$value';
    }

    if (resolved.contains('/avatars/') && avatarCacheBuster.isNotEmpty) {
      final sep = resolved.contains('?') ? '&' : '?';
      resolved = '$resolved${sep}cb=$avatarCacheBuster';
    }
    return resolved;
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
