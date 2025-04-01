// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';

import 'package:testing_api/models/menu_item.dart';
import 'package:testing_api/models/user.dart';
import 'package:testing_api/services/apis_services/group_apis/delivery_crew_apis.dart';
import 'package:testing_api/widgets/counter_widget.dart';

class DeliveryCrewTile extends StatelessWidget {
  final User user;
  final int index;
  final UserRole userRole;
  final bool enable;

  const DeliveryCrewTile(
      {super.key,
      required this.user,
      required this.userRole,
      required this.index,
      required this.enable});

  @override
  Widget build(BuildContext context) {
    final DeliveryCrewController crewController =
        Get.find<DeliveryCrewController>();
    return Card(
      // color: const Color.fromARGB(255, 210, 186, 186),
      child: ListTile(
        enabled: enable,
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
          enable ? user.email : "${user.email} (DELETED FROM DELIVERY)",
          style: TextStyle(
            fontFamily: "Lobster",
          ),
        ),
        trailing: userRole == UserRole.Manager
            ? IconButton(
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
                            bool result =
                                await DeliveryCrewApis.deleteDeliveryCrew(
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
