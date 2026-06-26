import 'dart:convert';

class SavedAddress {
  final String id;
  final String title;
  final String address;
  final double latitude;
  final double longitude;

  const SavedAddress({
    required this.id,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static SavedAddress fromJsonString(String jsonString) => SavedAddress.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
