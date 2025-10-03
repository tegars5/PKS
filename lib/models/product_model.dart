import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String supplierId;
  final String name;
  final String description;
  final double pricePerKg;
  final double stockInKg;
  final String location;
  final DateTime? createdAt;
  final List<String>? imageUrls;
  final bool isActive;

  const ProductModel({
    required this.id,
    required this.supplierId,
    required this.name,
    required this.description,
    required this.pricePerKg,
    required this.stockInKg,
    required this.location,
    this.createdAt,
    this.imageUrls,
    this.isActive = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      supplierId: json['supplier_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerKg: double.parse(json['price_per_kg'].toString()),
      stockInKg: double.parse(json['stock_in_kg'].toString()),
      location: json['location'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'] as List)
          : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'name': name,
      'description': description,
      'price_per_kg': pricePerKg,
      'stock_in_kg': stockInKg,
      'location': location,
      'created_at': createdAt?.toIso8601String(),
      'image_urls': imageUrls,
      'is_active': isActive,
    };
  }

  ProductModel copyWith({
    String? id,
    String? supplierId,
    String? name,
    String? description,
    double? pricePerKg,
    double? stockInKg,
    String? location,
    DateTime? createdAt,
    List<String>? imageUrls,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      stockInKg: stockInKg ?? this.stockInKg,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        supplierId,
        name,
        description,
        pricePerKg,
        stockInKg,
        location,
        createdAt,
        imageUrls,
        isActive,
      ];
}