class CartItem {
  final int cartId;
  final int userId;
  final int menuItemId;
  final int quantity;
  final String unitPrice;
  final String price;
  final String? menuItemTitle;

  CartItem({
    this.menuItemTitle,
    required this.cartId,
    required this.userId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json, String menuItemTitle) {
    return CartItem(
      cartId: json['id'],
      userId: json['user'],
      menuItemId: json['menuitem'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'],
      price: json['price'],
      menuItemTitle: menuItemTitle,
    );
  }
  Map<String, dynamic> toJsonApi() {
    return {
      'id': cartId,
      'user': userId,
      'menuitem': menuItemId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'price': price,
    };
  }
}
