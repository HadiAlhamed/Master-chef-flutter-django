import 'package:get/get.dart';
import 'package:testing_api/models/user.dart';

class CustomerController extends GetxController {
  List<RxBool> deleted = List.generate(1050, (index) => false.obs);
  RxBool isLoading = false.obs;
  List<User> customers = [];
  void deleteCustomer(int index) {
    deleted[index].value = true;
  }

  void addCustomer(int index) {
    deleted[index].value = false;
  }

  void changeIsLoading(bool value) {
    isLoading.value = value;
  }

  void init() {
    isLoading.value = true;

    for (int i = 0; i < deleted.length; i++) {
      deleted[i] = false.obs;
    }
    customers.clear();
  }
}
