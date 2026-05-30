/// Helpers for parsing API JSON bodies (`data` wrapper or flat object).
class ApiResponse {
  ApiResponse._();

  static Map<String, dynamic> unwrap(dynamic body) {
    if (body is! Map) {
      throw const FormatException('Invalid API response');
    }
    final map = Map<String, dynamic>.from(body);
    final data = map['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return map;
  }

  static List<dynamic> unwrapList(dynamic body) {
    if (body is! Map) {
      throw const FormatException('Invalid API response');
    }
    final data = body['data'];
    if (data is List) return data;
    throw const FormatException('Expected a list in response data');
  }
}
