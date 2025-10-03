import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../../models/order_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({
    required OrderRepository orderRepository,
  })  : _orderRepository = orderRepository,
        super(OrderInitial()) {
    on<GetOrders>(_onGetOrders);
    on<GetOrdersByBuyer>(_onGetOrdersByBuyer);
    on<GetOrdersBySupplier>(_onGetOrdersBySupplier);
    on<GetOrdersByDriver>(_onGetOrdersByDriver);
    on<GetOrderById>(_onGetOrderById);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrder>(_onUpdateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<AssignDriver>(_onAssignDriver);
  }

  Future<void> _onGetOrders(
    GetOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrders();
      emit(OrdersLoaded(orders));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetOrdersByBuyer(
    GetOrdersByBuyer event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrdersByBuyer(event.buyerId);
      emit(OrdersLoaded(orders));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetOrdersBySupplier(
    GetOrdersBySupplier event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrdersBySupplier(event.supplierId);
      emit(OrdersLoaded(orders));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetOrdersByDriver(
    GetOrdersByDriver event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await _orderRepository.getOrdersByDriver(event.driverId);
      emit(OrdersLoaded(orders));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetOrderById(
    GetOrderById event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final order = await _orderRepository.getOrderById(event.orderId);
      emit(OrderLoaded(order));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await _orderRepository.createOrder(event.order);
      emit(const OrderOperationSuccess('Order created successfully'));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await _orderRepository.updateOrder(event.order);
      emit(const OrderOperationSuccess('Order updated successfully'));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await _orderRepository.updateOrderStatus(event.orderId, event.status);
      emit(const OrderOperationSuccess('Order status updated successfully'));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onAssignDriver(
    AssignDriver event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await _orderRepository.assignDriver(event.orderId, event.driverId);
      emit(const OrderOperationSuccess('Driver assigned successfully'));
    } on AppException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('An unexpected error occurred: $e'));
    }
  }
}