import 'package:flutter/material.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/models/user.dart';
import 'package:testing_api/models/user_page.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/group_apis/delivery_crew_apis.dart';
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
              margin: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return DeliveryCrewTile(
                    user: users[index],
                    userRole: userRole,
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
}
