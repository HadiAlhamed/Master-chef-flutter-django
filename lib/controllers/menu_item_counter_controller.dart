import 'package:get/get.dart';

class MenuItemCounterController extends GetxController {
  List<RxInt> counter = List.filled(1050, 0.obs);
  void incrementCounter(int index) {
    counter[index].value++;
  }

  void decrementCounter(int index) {
    counter[index].value--;
  }
}
