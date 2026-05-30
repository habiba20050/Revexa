import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/utils/result.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';
import 'package:revexa/features/orders/data/repositories/orders_repository_impl.dart';

// ─── States ──────────────────────────────────────────────────────────────────

abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class OrderCreated extends OrdersState {
  final Order order;
  const OrderCreated(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderUpdated extends OrdersState {
  final Order order;
  const OrderUpdated(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderDeleted extends OrdersState {
  const OrderDeleted();
}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Cubit ───────────────────────────────────────────────────────────────────

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersInitial());

  Future<void> loadOrders() async {
    if (isClosed) return;
    emit(const OrdersLoading());
    try {
      final result = await _repository.getAllOrders();
      if (isClosed) return;
      if (result is Success) {
        emit(OrdersLoaded(result.data!));
      } else {
        emit(OrdersError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(OrdersError('Unexpected error: $e'));
    }
  }

  Future<void> createOrder({
    required String productId,
    required String serviceName,
    required CarDetails carDetails,
    required DateTime appointmentDate,
    required BookingLocation location,
  }) async {
    if (isClosed) return;
    emit(const OrdersLoading());
    try {
      final result = await _repository.createOrder(
        productId: productId,
        serviceName: serviceName,
        carDetails: carDetails,
        appointmentDate: appointmentDate,
        location: location,
      );
      if (isClosed) return;
      if (result is Success) {
        emit(OrderCreated(result.data!));
        // Refresh the list after creating
        await loadOrders();
      } else {
        emit(OrdersError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(OrdersError('Unexpected error: $e'));
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    if (isClosed) return;
    emit(const OrdersLoading());
    try {
      final result = await _repository.updateOrderStatus(orderId, status);
      if (isClosed) return;
      if (result is Success) {
        emit(OrderUpdated(result.data!));
        await loadOrders();
      } else {
        emit(OrdersError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(OrdersError('Unexpected error: $e'));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    if (isClosed) return;
    emit(const OrdersLoading());
    try {
      final result = await _repository.deleteOrder(orderId);
      if (isClosed) return;
      if (result is Success) {
        emit(const OrderDeleted());
        await loadOrders();
      } else {
        emit(OrdersError(result.failure!.message));
      }
    } catch (e) {
      if (!isClosed) emit(OrdersError('Unexpected error: $e'));
    }
  }
}
