// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/menu_item_controller.dart';

import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/services/apis_services/menu_apis/menu_apis.dart';
import 'package:testing_api/widgets/counter_widget.dart';
import 'package:testing_api/widgets/menu_bottomsheet.dart';

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
    final MenuItemController menuController = Get.find<MenuItemController>();
    return Card(
      // color: const Color.fromARGB(255, 210, 186, 186),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: !enable
              ? null
              : () async {
                  print("Menu Item Id from Menu Item Tile : ${menuItem.id}");

                  await Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: MenuBottomsheet(
                        menuItem: menuItem,
                      ),
                    ),
                  );
                },
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
            "${menuItem.category!.title} , ${menuItem.price} \$",
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
                                  bool result = await MenuApis.deleteMenuItem(
                                      menuItemId: menuItem.id!);
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
                                    menuController.deleteMenuItem(index);
                                    menuController.changeNeedUpdate(true);
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
      ),
    );
  }
}
