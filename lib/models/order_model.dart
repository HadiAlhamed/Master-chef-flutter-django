// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:testing_api/models/order_item_model.dart';

class OrderModel {
  final int orderId;
  final int userId;
  bool status;
  int? deliveryCrew;
  final String total;
  final String createdAt;
  String updatedAt;
  final List<OrderItemModel> orderItems;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.userId,
    required this.total,
    this.deliveryCrew,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  OrderModel copyWith({
    int? orderId,
    int? userId,
    String? total,
    String? createdAt,
    String? updatedAt,
    bool? status,
    int? deliveryCrew,
    List<OrderItemModel>? orderItems,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      deliveryCrew: deliveryCrew ?? this.deliveryCrew,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  Map<String, dynamic> toJsonApi() {
    return <String, dynamic>{
      'id': orderId,
      'user': userId,
      'status': status,
      'delivery_crew': deliveryCrew,
      'total': total,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'order_items': orderItems.map((x) => x.toJsonApi()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    print('status : ${json['status']}');
    return OrderModel(
      orderId: json['id'] as int,
      userId: json['user'] as int,
      status: json['status'] ?? false,
      deliveryCrew: json['delivery_crew'],
      total: json['total'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      orderItems: List<OrderItemModel>.from(
        (json['order_items'] as List).map(
          (item) => OrderItemModel.fromJson(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, userId: $userId, total: $total, createdAt: $createdAt, updatedAt: $updatedAt, orderItems: $orderItems)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.userId == userId &&
        other.total == total &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        listEquals(other.orderItems, orderItems);
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        userId.hashCode ^
        total.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        orderItems.hashCode;
  }
}
