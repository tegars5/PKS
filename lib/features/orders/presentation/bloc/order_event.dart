part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class GetOrders extends OrderEvent {}

class GetOrdersByBuyer extends OrderEvent {
  final String buyerId;

  const GetOrdersByBuyer(this.buyerId);

  @override
  List<Object> get props => [buyerId];
}

class GetOrdersBySupplier extends OrderEvent {
  final String supplierId;

  const GetOrdersBySupplier(this.supplierId);

  @override
  List<Object> get props => [supplierId];
}

class GetOrdersByDriver extends OrderEvent {
  final String driverId;

  const GetOrdersByDriver(this.driverId);

  @override
  List<Object> get props => [driverId];
}

class GetOrderById extends OrderEvent {
  final String orderId;

  const GetOrderById(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class CreateOrder extends OrderEvent {
  final OrderModel order;

  const CreateOrder(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrder extends OrderEvent {
  final OrderModel order;

  const UpdateOrder(this.order);

  @override
  List<Object> get props => [order];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatus(this.orderId, this.status);

  @override
  List<Object> get props => [orderId, status];
}

class AssignDriver extends OrderEvent {
  final String orderId;
  final String driverId;

  const AssignDriver(this.orderId, this.driverId);

  @override
  List<Object> get props => [orderId, driverId];
}