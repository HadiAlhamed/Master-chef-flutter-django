// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final int index;
  final UserRole userRole;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.index,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          cartItem.menuItemTitle!,
          style: TextStyle(
            fontFamily: "Lobster",
            color: Colors.amber,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          "${cartItem.unitPrice} | #${cartItem.quantity} | total : ${cartItem.price}",
          style: TextStyle(
            fontFamily: "Lobster",
          ),
        ),
      ),
    );
  }
}
