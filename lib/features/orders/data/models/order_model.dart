import 'package:equatable/equatable.dart';

class CarDetails extends Equatable {
  final String model;
  final String plateNumber;
  final String? color;

  const CarDetails({
    required this.model,
    required this.plateNumber,
    this.color,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      model: json['model']?.toString() ?? '',
      plateNumber: json['plateNumber']?.toString() ?? '',
      color: json['color']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'model': model,
        'plateNumber': plateNumber,
        if (color != null) 'color': color,
      };

  @override
  List<Object?> get props => [model, plateNumber, color];
}

class BookingLocation extends Equatable {
  final String title;
  final String address;
  final double latitude;
  final double longitude;

  const BookingLocation({
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  List<Object?> get props => [title, address, latitude, longitude];
}

class OrderService extends Equatable {
  final String id;
  final String title;
  final double price;

  const OrderService({required this.id, required this.title, required this.price});

  factory OrderService.fromJson(Map<String, dynamic> json) {
    return OrderService(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [id, title, price];
}

class Order extends Equatable {
  final String id;
  final String userId;
  final OrderService? service;
  final CarDetails carDetails;
  final DateTime appointmentDate;
  final String status;
  final double totalAmount;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.userId,
    this.service,
    required this.carDetails,
    required this.appointmentDate,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final serviceData = json['service'];
    return Order(
      id: json['_id']?.toString() ?? '',
      userId: (json['user'] is Map)
          ? (json['user'] as Map)['_id']?.toString() ?? ''
          : json['user']?.toString() ?? '',
      service: serviceData is Map<String, dynamic>
          ? OrderService.fromJson(serviceData)
          : null,
      carDetails: CarDetails.fromJson(json['carDetails'] as Map<String, dynamic>? ?? {}),
      appointmentDate: DateTime.tryParse(json['appointmentDate']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in-progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [id, userId, service, carDetails, appointmentDate, status, totalAmount, createdAt];
}
