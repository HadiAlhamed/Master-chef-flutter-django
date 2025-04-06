class OrderItemModel {
  final int orderItemId;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final String unitPrice;
  final String price;

  OrderItemModel({
    required this.orderItemId,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['id'] as int,
      orderId: json['order'] as int,
      menuItemId: json['menuitem'] as int,
      quantity: json['quantity'] as int,
      unitPrice: json['unit_price'] as String,
      price: json['price'] as String,
    );
  }
  Map<String, dynamic> toJsonApi() {
    return {
      'id': orderItemId,
      'order': orderId,
      'menuitem': menuItemId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'price': price,
    };
  }
}
