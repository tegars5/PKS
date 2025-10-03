import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String buyerId;
  final String supplierId;
  final String? driverId;
  final String productId;
  final double quantityInKg;
  final double totalPrice;
  final String shippingAddress;
  final String status;
  final DateTime? createdAt;
  final DateTime? confirmedAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final String? notes;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.supplierId,
    this.driverId,
    required this.productId,
    required this.quantityInKg,
    required this.totalPrice,
    required this.shippingAddress,
    required this.status,
    this.createdAt,
    this.confirmedAt,
    this.shippedAt,
    this.deliveredAt,
    this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      buyerId: json['buyer_id'] as String,
      supplierId: json['supplier_id'] as String,
      driverId: json['driver_id'] as String?,
      productId: json['product_id'] as String,
      quantityInKg: double.parse(json['quantity_in_kg'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      shippingAddress: json['shipping_address'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      shippedAt: json['shipped_at'] != null
          ? DateTime.parse(json['shipped_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyerId,
      'supplier_id': supplierId,
      'driver_id': driverId,
      'product_id': productId,
      'quantity_in_kg': quantityInKg,
      'total_price': totalPrice,
      'shipping_address': shippingAddress,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'notes': notes,
    };
  }

  OrderModel copyWith({
    String? id,
    String? buyerId,
    String? supplierId,
    String? driverId,
    String? productId,
    double? quantityInKg,
    double? totalPrice,
    String? shippingAddress,
    String? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      supplierId: supplierId ?? this.supplierId,
      driverId: driverId ?? this.driverId,
      productId: productId ?? this.productId,
      quantityInKg: quantityInKg ?? this.quantityInKg,
      totalPrice: totalPrice ?? this.totalPrice,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        buyerId,
        supplierId,
        driverId,
        productId,
        quantityInKg,
        totalPrice,
        shippingAddress,
        status,
        createdAt,
        confirmedAt,
        shippedAt,
        deliveredAt,
        notes,
      ];
}