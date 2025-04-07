// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';
import 'package:testing_api/models/user_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/group_apis/delivery_crew_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/views/customers_page.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/delivery_crew_tile.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';

class DeliveryCrewPage extends StatefulWidget {
  const DeliveryCrewPage({
    super.key,
  });

  @override
  State<DeliveryCrewPage> createState() => _DeliveryCrewPageState();
}

class _DeliveryCrewPageState extends State<DeliveryCrewPage> {
  bool isLoading = true;
  UserRole userRole = UserRole.Customer;
  final DeliveryCrewController crewController =
      Get.find<DeliveryCrewController>();
  @override
  void initState() {
    super.initState();
    if (Api.box.read("role") == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role") == 'delivery') {
      userRole = UserRole.Delivery;
    }
    _fetchDeliveryCrew();
  }

  Future<void> _fetchDeliveryCrew() async {
    crewController.init();
    UserPage userPage = await DeliveryCrewApis.getAllDeliveryCrew();
    for (var item in userPage.users) {
      crewController.addToUsers(item);
    }
    while (userPage.nextPageUrl != null) {
      userPage =
          await DeliveryCrewApis.getAllDeliveryCrew(url: userPage.nextPageUrl);
      for (var item in userPage.users) {
        crewController.addToUsers(item);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        myTitle: "Delivery",
      ),
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: crewController.users.isEmpty
                  ? const Text(
                      "You have no delivery crew.",
                      style: atitleTextStyle1,
                    )
                  : ListView.builder(
                      itemCount: crewController.users.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            horizontalOffset: 70.0,
                            child: FadeInAnimation(
                              child: Obx(
                                () {
                                  return DeliveryCrewTile(
                                    user: crewController.users[index],
                                    userRole: userRole,
                                    index: index,
                                    enable:
                                        !crewController.deleted[index].value,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: crewController.pickDelivery
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Get.off(
                  () => CustomersPage(addToDelivery: true),
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 400),
                );
              },
              label: const Text("Add Delivery"),
              icon: const Icon(Icons.add),
            ),
      drawer: userRole == UserRole.Manager
          ? ManagerDrawer()
          : userRole == UserRole.Customer
              ? CustomerDrawer()
              : null,
      drawerEnableOpenDragGesture: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    crewController.changePickDelivery(value: false);
    crewController.init();
  }
}
