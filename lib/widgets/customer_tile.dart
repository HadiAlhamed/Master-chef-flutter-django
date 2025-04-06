// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/customer_controller.dart';
import 'package:testing_api/models/user.dart';
import 'package:testing_api/services/apis_services/group_apis/delivery_crew_apis.dart';

class CustomerTile extends StatelessWidget {
  final User user;
  final int index;
  final UserRole userRole;
  final bool enable;
  final bool addToDelivery;
  const CustomerTile({
    super.key,
    required this.user,
    required this.userRole,
    required this.index,
    required this.enable,
    required this.addToDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.find<CustomerController>();
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
                : "${index + 1} ${user.username} (ADDED TO DELIVERY)",
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
                  onPressed: !enable || !addToDelivery
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
                              "The user will be added to delivery crew",
                              textAlign: TextAlign.center,
                            ),
                            btnCancelText: "Cancel",
                            btnOkText: "Add",
                            btnOkOnPress: () async {
                              //add to delivery crew
                              bool result =
                                  await DeliveryCrewApis.addDeliveryCrew(
                                userId: user.id,
                              );

                              Get.showSnackbar(
                                GetSnackBar(
                                  duration: const Duration(seconds: 5),
                                  title: result ? "Info" : "Error",
                                  message: result
                                      ? "User Added To Delivery Crew"
                                      : "An Error Has Occurred, try later.",
                                  icon:
                                      Icon(result ? Icons.check : Icons.error),
                                  backgroundColor:
                                      result ? Colors.green : Colors.red,
                                ),
                              );
                              if (result) {
                                //do something to customerController
                                controller.deleteCustomer(index);
                              }
                            },
                            btnCancelOnPress: () {},
                          ).show();
                        },
                  icon: addToDelivery && enable
                      ? Icon(
                          Icons.add,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink(),
                )
              : null,
        ),
      ),
    );
  }
}
