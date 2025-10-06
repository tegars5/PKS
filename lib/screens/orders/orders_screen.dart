import 'package:flutter/material.dart';
import '../../models/order.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    // Mock data - replace with actual API call
    orders = [
      Order(
        id: 'ORD001',
        userId: 'user1',
        items: [
          OrderItem(
            productId: '1',
            productName: 'Cangkang Sawit Grade A',
            quantity: 2,
            price: 150000,
          ),
        ],
        totalAmount: 300000,
        status: OrderStatus.shipped,
        orderDate: DateTime.now().subtract(Duration(days: 2)),
        shippingAddress: 'Jl. Raya No. 123, Jakarta',
        trackingNumber: 'TRK001234567',
      ),
      // Add more mock orders...
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan Saya'),
        backgroundColor: Colors.green,
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text('Belum ada pesanan'),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/products');
                    },
                    child: Text('Mulai Belanja'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(order.status),
                      child: Icon(
                        _getStatusIcon(order.status),
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Order #${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total: Rp ${order.totalAmount.toStringAsFixed(0)}',
                        ),
                        Text('Status: ${_getStatusText(order.status)}'),
                        Text(
                          '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.processing:
        return Icons.settings;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Konfirmasi';
      case OrderStatus.confirmed:
        return 'Dikonfirmasi';
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.shipped:
        return 'Dikirim';
      case OrderStatus.delivered:
        return 'Diterima';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}
