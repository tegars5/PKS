import '../../../../models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderModel>> getOrdersByBuyer(String buyerId);
  Future<List<OrderModel>> getOrdersBySupplier(String supplierId);
  Future<List<OrderModel>> getOrdersByDriver(String driverId);
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> assignDriver(String orderId, String driverId);
}