import 'package:get/get.dart';
import 'package:testing_api/models/user.dart';

class DeliveryCrewController extends GetxController {
  List<RxBool> deleted = List.generate(1050, (index) => false.obs);
  List<User> users = <User>[];
  bool pickDelivery = false;

  void deleteDeliveryCrew(int index) {
    deleted[index].value = true;
  }

  void unDeleteDeliveryCrew(int index) {
    deleted[index].value = false;
  }

  void addToUsers(User user) {
    users.add(user);
  }

  void changePickDelivery({required bool value}) {
    pickDelivery = value;
  }

  void init() {
    for (int i = 0; i < deleted.length; i++) {
      deleted[i].value = false;
    }
    // pickDelivery = false;
    users.clear();
  }
}
