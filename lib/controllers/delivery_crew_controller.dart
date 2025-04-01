import 'package:get/get.dart';

class DeliveryCrewController extends GetxController {
  List<RxBool> deleted = List.generate(1050, (index) => false.obs);
  void deleteDeliveryCrew(int index) {
    deleted[index].value = true;
  }

  void unDeleteDeliveryCrew(int index) {
    deleted[index].value = false;
  }

  void init() {
    for (int i = 0; i < deleted.length; i++) {
      deleted[i].value = false;
    }
  }
}
