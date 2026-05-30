import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';
import 'package:revexa/features/orders/data/order_id_resolver.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<Order>> getAllOrders();
  Future<Order> getOrderById(String id);
  Future<Order> createOrder({
    required String productId,
    required String serviceName,
    required CarDetails carDetails,
    required DateTime appointmentDate,
    required BookingLocation location,
  });
  Future<Order> updateOrderStatus(String orderId, String status);
  Future<void> deleteOrder(String orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final Dio _dio;
  OrdersRemoteDataSourceImpl() : _dio = DioClient.instance.dio;

  @override
  Future<List<Order>> getAllOrders() async {
    try {
      final response = await _dio.get(ApiEndpoints.orders);
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Order> getOrderById(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.orderById(id));
      return Order.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Order> createOrder({
    required String productId,
    required String serviceName,
    required CarDetails carDetails,
    required DateTime appointmentDate,
    required BookingLocation location,
  }) async {
    try {
      final resolvedId = await OrderIdResolver.resolve(
        fallbackId: productId,
        serviceName: serviceName,
      );

      final body = {
        'carDetails': carDetails.toJson(),
        'appointmentDate': appointmentDate.toIso8601String(),
        'location': location.toJson(),
        'address': location.address,
        'latitude': location.latitude,
        'longitude': location.longitude,
      };

      final response = await _dio.post(
        ApiEndpoints.createOrder(resolvedId),
        data: body,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final data = responseData['data'];
        if (data is Map<String, dynamic>) {
          return Order.fromJson(data);
        }
      }
      throw Exception('Invalid order response from server');
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<Order> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.orderById(orderId),
        data: {'status': status},
      );
      return Order.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      await _dio.delete(ApiEndpoints.orderById(orderId));
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    }
  }
}
