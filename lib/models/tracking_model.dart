import 'package:equatable/equatable.dart';

class TrackingModel extends Equatable {
  final String id;
  final String orderId;
  final String driverId;
  final double latitude;
  final double longitude;
  final String statusMessage;
  final DateTime createdAt;

  const TrackingModel({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.latitude,
    required this.longitude,
    required this.statusMessage,
    required this.createdAt,
  });

  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      driverId: json['driver_id'] as String,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      statusMessage: json['status_message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_id': driverId,
      'latitude': latitude,
      'longitude': longitude,
      'status_message': statusMessage,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TrackingModel copyWith({
    String? id,
    String? orderId,
    String? driverId,
    double? latitude,
    double? longitude,
    String? statusMessage,
    DateTime? createdAt,
  }) {
    return TrackingModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      driverId: driverId ?? this.driverId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      statusMessage: statusMessage ?? this.statusMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        driverId,
        latitude,
        longitude,
        statusMessage,
        createdAt,
      ];
}