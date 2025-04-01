import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/delivery_crew_controller.dart';
import 'package:testing_api/models/user.dart';
import 'package:testing_api/models/user_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/group_apis/delivery_crew_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/delivery_crew_tile.dart';
import 'package:testing_api/widgets/manager_drawer.dart';

class DeliveryCrewPage extends StatefulWidget {
  const DeliveryCrewPage({super.key});

  @override
  State<DeliveryCrewPage> createState() => _DeliveryCrewPageState();
}

class _DeliveryCrewPageState extends State<DeliveryCrewPage> {
  List<User> users = <User>[];
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
    users.clear();
    UserPage userPage = await DeliveryCrewApis.getAllDeliveryCrew();
    for (var item in userPage.users) {
      users.add(item);
    }
    while (userPage.nextPageUrl != null) {
      userPage =
          await DeliveryCrewApis.getAllDeliveryCrew(url: userPage.nextPageUrl);
      for (var item in userPage.users) {
        users.add(item);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(child: const CircularProgressIndicator())
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () {
                      return DeliveryCrewTile(
                        user: users[index],
                        userRole: userRole,
                        index: index,
                        enable: !crewController.deleted[index].value,
                      );
                    },
                  );
                },
              ),
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
    crewController.init();
  }
}
