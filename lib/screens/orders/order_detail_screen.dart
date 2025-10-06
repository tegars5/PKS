import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../tracking/tracking_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan'),
        backgroundColor: Colors.green,
        actions: [
          if (order.status == OrderStatus.shipped)
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TrackingScreen(trackingNumber: order.trackingNumber),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow('ID Pesanan', order.id),
                    _buildInfoRow(
                      'Tanggal',
                      '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                    ),
                    _buildInfoRow('Status', _getStatusText(order.status)),
                    if (order.trackingNumber.isNotEmpty)
                      _buildInfoRow('No. Resi', order.trackingNumber),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Items
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produk Dipesan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...order.items.map(
                      (item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Qty: ${item.quantity}'),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp ${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Shipping Address
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat Pengiriman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(order.shippingAddress),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Action Buttons
            if (order.status == OrderStatus.pending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Batalkan Pesanan'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
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

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Batalkan Pesanan'),
        content: Text('Apakah Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement cancel order logic
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Pesanan dibatalkan')));
            },
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }
}
