// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';
import 'package:testing_api/controllers/orders_controller.dart';

import 'package:testing_api/models/user.dart';
import 'package:testing_api/services/apis_services/group_apis/delivery_crew_apis.dart';
import 'package:testing_api/services/apis_services/order_apis/order_apis.dart';
import 'package:testing_api/views/orders_page.dart';
import 'package:testing_api/widgets/my_snackbar.dart';

class DeliveryCrewTile extends StatelessWidget {
  final User user;
  final int index;
  final UserRole userRole;
  final bool enable;
  final DeliveryCrewController crewController =
      Get.find<DeliveryCrewController>();
  final OrdersController ordersController = Get.find<OrdersController>();
  DeliveryCrewTile(
      {super.key,
      required this.user,
      required this.userRole,
      required this.index,
      required this.enable});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // color: const Color.fromARGB(255, 210, 186, 186),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          enabled: enable,
          contentPadding: const EdgeInsets.all(10),
          title: Text(
            enable
                ? "${index + 1} ${user.username}"
                : "${index + 1} ${user.email} (DELETED FROM DELIVERY)",
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
          trailing: userRole == UserRole.Delivery
              ? null
              : crewController.pickDelivery
                  ? IconButton(
                      onPressed: () async {
                        bool result = await OrderApis.updateOrderDelivery(
                          orderId: ordersController.orderIdToPick,
                          deliveryId: crewController.users[index].id,
                          status : false,
                        );
                        Get.showSnackbar(
                          MySnackbar(
                            success: result,
                            title: "Pick Delivery",
                            message: result
                                ? "delivery crew assigned to order successfully"
                                : "failed to assign a delivery , please try later",
                          ),
                        );
                        crewController.changePickDelivery(value: false);
                        ordersController.setDeliveryFor(
                          deliveryId: crewController.users[index].id,
                        );
                        Get.off(
                          () => OrdersPage(),
                          transition: Transition.fade,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 30,
                      ),
                    )
                  : handleDeleteDelivery(context, crewController),
        ),
      ),
    );
  }

  IconButton handleDeleteDelivery(
      BuildContext context, DeliveryCrewController crewController) {
    return IconButton(
      onPressed: !enable
          ? null
          : () async {
              //delete Delivery guy from here
              //apply deleteDeliveryCrewApi here
              AwesomeDialog(
                context: context,
                alignment: Alignment.center,
                animType: AnimType.leftSlide,
                dialogType: DialogType.warning,
                body: const Text(
                  "The user will be deleted from Delivery Crew...",
                  textAlign: TextAlign.center,
                ),
                btnCancelText: "Delete",
                btnOkText: "Cancel",
                btnOkOnPress: () {},
                btnCancelOnPress: () async {
                  //delete
                  bool result = await DeliveryCrewApis.deleteDeliveryCrew(
                    userId: user.id,
                  );
                  Get.showSnackbar(
                    GetSnackBar(
                      duration: const Duration(seconds: 5),
                      title: "Deleting Delivery Crew",
                      message: result
                          ? "Deleted Successfully"
                          : "An error has happened while deleting , try later.",
                    ),
                  );
                  if (result) {
                    crewController.deleteDeliveryCrew(index);
                  }
                },
              ).show();
            },
      icon: !enable
          ? const SizedBox.shrink()
          : Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
    );
  }
}
