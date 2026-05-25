import 'package:dio/dio.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<Order>> getAllOrders();
  Future<Order> getOrderById(String id);
  Future<Order> createOrder({
    required String productId,
    required CarDetails carDetails,
    required DateTime appointmentDate,
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
    required CarDetails carDetails,
    required DateTime appointmentDate,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createOrder(productId),
        data: {
          'carDetails': carDetails.toJson(),
          'appointmentDate': appointmentDate.toIso8601String(),
        },
      );
      return Order.fromJson(response.data['data'] as Map<String, dynamic>);
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
