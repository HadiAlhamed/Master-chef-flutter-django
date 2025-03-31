// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/widgets/counter_widget.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final int index;
  const MenuItemTile({
    super.key,
    required this.menuItem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: const Color.fromARGB(255, 210, 186, 186),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          menuItem.title,
          style: TextStyle(
            fontFamily: "Lobster",
            color: Colors.amber,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          "${menuItem.category.title} , ${menuItem.price} \$",
          style: TextStyle(
            fontFamily: "Lobster",
          ),
        ),
        trailing: CounterWidget(index: index),
      ),
    );
  }
}
