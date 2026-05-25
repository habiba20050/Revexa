import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';

abstract interface class OrdersRepository {
  Future<Result<List<Order>>> getAllOrders();
  Future<Result<Order>> getOrderById(String id);
  Future<Result<Order>> createOrder({
    required String productId,
    required CarDetails carDetails,
    required DateTime appointmentDate,
  });
  Future<Result<Order>> updateOrderStatus(String orderId, String status);
  Future<Result<void>> deleteOrder(String orderId);
}

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remote;
  OrdersRepositoryImpl(this._remote);

  @override
  Future<Result<List<Order>>> getAllOrders() async {
    try {
      final result = await _remote.getAllOrders();
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Order>> getOrderById(String id) async {
    try {
      final result = await _remote.getOrderById(id);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Order>> createOrder({
    required String productId,
    required CarDetails carDetails,
    required DateTime appointmentDate,
  }) async {
    try {
      final result = await _remote.createOrder(
        productId: productId,
        carDetails: carDetails,
        appointmentDate: appointmentDate,
      );
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<Order>> updateOrderStatus(String orderId, String status) async {
    try {
      final result = await _remote.updateOrderStatus(orderId, status);
      return Success(result);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteOrder(String orderId) async {
    try {
      await _remote.deleteOrder(orderId);
      return const Success(null);
    } catch (e) {
      return ResultFailure(ErrorHandler.toFailure(e));
    }
  }
}
