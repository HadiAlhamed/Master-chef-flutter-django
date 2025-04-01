// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:testing_api/Enums/user_role.dart';

import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/user.dart';
import 'package:testing_api/widgets/counter_widget.dart';

class DeliveryCrewTile extends StatelessWidget {
  final User user;

  final UserRole userRole;

  const DeliveryCrewTile(
      {super.key, required this.user, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: const Color.fromARGB(255, 210, 186, 186),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          user.username,
          style: TextStyle(
            fontFamily: "Lobster",
            color: Colors.amber,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          user.email,
          style: TextStyle(
            fontFamily: "Lobster",
          ),
        ),
        trailing: userRole == UserRole.Manager
            ? IconButton(
                onPressed: () {
                  //delete Delivery guy from here
                  //apply deleteDeliveryCrewApi here
                },
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              )
            : null,
      ),
    );
  }
}
