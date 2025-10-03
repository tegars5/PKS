import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/repositories/order_repository.dart';
import '../../../../models/order_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class OrderRepositoryImpl implements OrderRepository {
  final supabase.SupabaseClient _supabaseClient;

  OrderRepositoryImpl(this._supabaseClient);

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      print('=== GET ORDERS DEBUG START ===');
      
      final response = await _supabaseClient
          .from('orders')
          .select('*, products!orders_product_id_fkey(name, price_per_kg), profiles!orders_buyer_id_fkey(full_name), profiles!orders_supplier_id_fkey(full_name)')
          .order('created_at', ascending: false);

      print('Orders response: $response');
      
      List<OrderModel> orders = [];
      for (var item in response) {
        orders.add(OrderModel.fromJson(item));
      }
      
      print('Orders parsed successfully: ${orders.length} items');
      print('=== GET ORDERS DEBUG END ===');
      return orders;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getOrders: ${e.message}');
      print('=== GET ORDERS DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getOrders: $e');
      print('=== GET ORDERS DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersByBuyer(String buyerId) async {
    try {
      print('=== GET ORDERS BY BUYER DEBUG START ===');
      print('Getting orders for buyer: $buyerId');
      
      final response = await _supabaseClient
          .from('orders')
          .select('*, products!orders_product_id_fkey(name, price_per_kg), profiles!orders_supplier_id_fkey(full_name)')
          .eq('buyer_id', buyerId)
          .order('created_at', ascending: false);

      print('Orders by buyer response: $response');
      
      List<OrderModel> orders = [];
      for (var item in response) {
        orders.add(OrderModel.fromJson(item));
      }
      
      print('Orders by buyer parsed successfully: ${orders.length} items');
      print('=== GET ORDERS BY BUYER DEBUG END ===');
      return orders;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getOrdersByBuyer: ${e.message}');
      print('=== GET ORDERS BY BUYER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getOrdersByBuyer: $e');
      print('=== GET ORDERS BY BUYER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersBySupplier(String supplierId) async {
    try {
      print('=== GET ORDERS BY SUPPLIER DEBUG START ===');
      print('Getting orders for supplier: $supplierId');
      
      final response = await _supabaseClient
          .from('orders')
          .select('*, products!orders_product_id_fkey(name, price_per_kg), profiles!orders_buyer_id_fkey(full_name)')
          .eq('supplier_id', supplierId)
          .order('created_at', ascending: false);

      print('Orders by supplier response: $response');
      
      List<OrderModel> orders = [];
      for (var item in response) {
        orders.add(OrderModel.fromJson(item));
      }
      
      print('Orders by supplier parsed successfully: ${orders.length} items');
      print('=== GET ORDERS BY SUPPLIER DEBUG END ===');
      return orders;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getOrdersBySupplier: ${e.message}');
      print('=== GET ORDERS BY SUPPLIER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getOrdersBySupplier: $e');
      print('=== GET ORDERS BY SUPPLIER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersByDriver(String driverId) async {
    try {
      print('=== GET ORDERS BY DRIVER DEBUG START ===');
      print('Getting orders for driver: $driverId');
      
      final response = await _supabaseClient
          .from('orders')
          .select('*, products!orders_product_id_fkey(name, price_per_kg), profiles!orders_buyer_id_fkey(full_name), profiles!orders_supplier_id_fkey(full_name)')
          .eq('driver_id', driverId)
          .order('created_at', ascending: false);

      print('Orders by driver response: $response');
      
      List<OrderModel> orders = [];
      for (var item in response) {
        orders.add(OrderModel.fromJson(item));
      }
      
      print('Orders by driver parsed successfully: ${orders.length} items');
      print('=== GET ORDERS BY DRIVER DEBUG END ===');
      return orders;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getOrdersByDriver: ${e.message}');
      print('=== GET ORDERS BY DRIVER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getOrdersByDriver: $e');
      print('=== GET ORDERS BY DRIVER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      print('=== GET ORDER BY ID DEBUG START ===');
      print('Getting order with ID: $orderId');
      
      final response = await _supabaseClient
          .from('orders')
          .select('*, products!orders_product_id_fkey(name, price_per_kg), profiles!orders_buyer_id_fkey(full_name), profiles!orders_supplier_id_fkey(full_name)')
          .eq('id', orderId)
          .single();

      print('Order response: $response');
      
      final order = OrderModel.fromJson(response);
      print('Order parsed successfully: ${order.id}');
      print('=== GET ORDER BY ID DEBUG END ===');
      return order;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getOrderById: ${e.message}');
      print('=== GET ORDER BY ID DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getOrderById: $e');
      print('=== GET ORDER BY ID DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      print('=== CREATE ORDER DEBUG START ===');
      print('Creating order for product: ${order.productId}');
      
      final response = await _supabaseClient
          .from('orders')
          .insert(order.toJson())
          .select()
          .single();

      print('Create order response: $response');
      
      final newOrder = OrderModel.fromJson(response);
      print('Order created successfully: ${newOrder.id}');
      print('=== CREATE ORDER DEBUG END ===');
      return newOrder;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in createOrder: ${e.message}');
      print('=== CREATE ORDER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in createOrder: $e');
      print('=== CREATE ORDER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    try {
      print('=== UPDATE ORDER DEBUG START ===');
      print('Updating order: ${order.id}');
      
      final response = await _supabaseClient
          .from('orders')
          .update(order.toJson())
          .eq('id', order.id)
          .select()
          .single();

      print('Update order response: $response');
      
      final updatedOrder = OrderModel.fromJson(response);
      print('Order updated successfully: ${updatedOrder.id}');
      print('=== UPDATE ORDER DEBUG END ===');
      return updatedOrder;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in updateOrder: ${e.message}');
      print('=== UPDATE ORDER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in updateOrder: $e');
      print('=== UPDATE ORDER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      print('=== UPDATE ORDER STATUS DEBUG START ===');
      print('Updating status for order: $orderId to $status');
      
      Map<String, dynamic> updateData = {'status': status};
      
      // Add timestamp based on status
      if (status == 'confirmed') {
        updateData['confirmed_at'] = DateTime.now().toIso8601String();
      } else if (status == 'shipped') {
        updateData['shipped_at'] = DateTime.now().toIso8601String();
      } else if (status == 'delivered') {
        updateData['delivered_at'] = DateTime.now().toIso8601String();
      }
      
      await _supabaseClient
          .from('orders')
          .update(updateData)
          .eq('id', orderId);
      
      print('Order status updated successfully');
      print('=== UPDATE ORDER STATUS DEBUG END ===');
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in updateOrderStatus: ${e.message}');
      print('=== UPDATE ORDER STATUS DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in updateOrderStatus: $e');
      print('=== UPDATE ORDER STATUS DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> assignDriver(String orderId, String driverId) async {
    try {
      print('=== ASSIGN DRIVER DEBUG START ===');
      print('Assigning driver: $driverId to order: $orderId');
      
      await _supabaseClient
          .from('orders')
          .update({
            'driver_id': driverId,
            'status': 'shipped',
            'shipped_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
      
      print('Driver assigned successfully');
      print('=== ASSIGN DRIVER DEBUG END ===');
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in assignDriver: ${e.message}');
      print('=== ASSIGN DRIVER DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in assignDriver: $e');
      print('=== ASSIGN DRIVER DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}