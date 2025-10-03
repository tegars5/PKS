part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderLoaded extends OrderState {
  final OrderModel order;

  const OrderLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class OrderOperationSuccess extends OrderState {
  final String message;

  const OrderOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}