import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:testing_api/Enums/user_role.dart';
import 'package:testing_api/controllers/customer_controller.dart';
import 'package:testing_api/services/api.dart';
import 'package:testing_api/services/apis_services/group_apis/customer_apis.dart';
import 'package:testing_api/text_styles.dart';
import 'package:testing_api/widgets/customer_drawer.dart';
import 'package:testing_api/widgets/customer_tile.dart';
import 'package:testing_api/widgets/main_appbar.dart';
import 'package:testing_api/widgets/manager_drawer.dart';

class CustomersPage extends StatefulWidget {
  final bool addToDelivery;
  const CustomersPage({super.key, required this.addToDelivery});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  UserRole userRole = UserRole.Customer;
  final CustomerController customerController = Get.find<CustomerController>();
  @override
  void initState() {
    super.initState();
    if (Api.box.read("role") == 'manager') {
      userRole = UserRole.Manager;
    } else if (Api.box.read("role") == 'delivery') {
      userRole = UserRole.Delivery;
    }
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    customerController.init();
    customerController.customers = await CustomerApis.getAllCustomers();
    customerController.changeIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        myTitle: "Customers",
      ),
      body: Obx(
        () {
          if (customerController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            child: customerController.customers.isEmpty
                ? const Text(
                    "You have no customers",
                    style: atitleTextStyle1,
                  )
                : RefreshIndicator(
                    onRefresh: _fetchCustomers,
                    child: ListView.builder(
                      itemCount: customerController.customers.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            duration: const Duration(milliseconds: 400),
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: !widget.addToDelivery
                                  ? CustomerTile(
                                      user: customerController.customers[index],
                                      userRole: userRole,
                                      index: index,
                                      enable: true,
                                      addToDelivery: widget.addToDelivery,
                                    )
                                  : Obx(
                                      () {
                                        return CustomerTile(
                                          user: customerController
                                              .customers[index],
                                          userRole: userRole,
                                          index: index,
                                          enable: !customerController
                                              .deleted[index].value,
                                          addToDelivery: widget.addToDelivery,
                                        );
                                      },
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
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
    customerController.init();
  }
}
