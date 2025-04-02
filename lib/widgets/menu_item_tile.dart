// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';

import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/widgets/counter_widget.dart';

class MenuItemTile extends StatelessWidget {
  final MenuItem menuItem;
  final int index;
  final UserRole userRole;
  final bool enable;
  const MenuItemTile({
    super.key,
    required this.menuItem,
    required this.index,
    required this.userRole,
    required this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: const Color.fromARGB(255, 210, 186, 186),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          enable ? menuItem.title : "${menuItem.title} (DELETED)",
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
        trailing: userRole == UserRole.Customer
            ? CounterWidget(index: index)
            : userRole == UserRole.Manager
                ? IconButton(
                    onPressed: !enable
                        ? null
                        : () async {
                            bool result = true;
                            AwesomeDialog(
                              context: context,
                              alignment: Alignment.center,
                              animType: AnimType.leftSlide,
                              dialogType: DialogType.warning,
                              body: const Text(
                                "The menu item will be deleted",
                                textAlign: TextAlign.center,
                              ),
                              btnCancelText: "Delete",
                              btnOkText: "Cancel",
                              btnOkOnPress: () {},
                              btnCancelOnPress: () async {
                                //delete menu item api
                                bool result = true;
                                Get.showSnackbar(
                                  GetSnackBar(
                                    duration: const Duration(seconds: 5),
                                    title: result ? "Info" : "Error",
                                    message: result
                                        ? "MenuItem Deleted From Menu"
                                        : "An Error Has Occurred, try later.",
                                    icon: Icon(
                                        result ? Icons.check : Icons.error),
                                    backgroundColor:
                                        result ? Colors.green : Colors.red,
                                  ),
                                );
                                if (result) {
                                  //do something to menuItem Controller
                                }
                              },
                            ).show();
                          },
                    icon: enable && userRole == UserRole.Manager
                        ? Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          )
                        : const SizedBox.shrink(),
                  )
                : null,
      ),
    );
  }
}
