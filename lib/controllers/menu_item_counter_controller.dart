import 'package:get/get.dart';

class MenuItemCounterController extends GetxController {
  List<RxInt> counter = List.generate(1050, (index) {
    return 0.obs;
  });
  bool needUpdate = false;
  void incrementCounter(int index) {
    counter[index].value++;
  }

  void decrementCounter(int index) {
    if (counter[index].value > 0) {
      counter[index].value--;
    }
  }

  void changeNeedUpdate(bool value) => needUpdate = value;
  
  void clear() {
    counter = List.generate(1050, (index) {
      return 0.obs;
    });
    needUpdate = false;
  }
}
