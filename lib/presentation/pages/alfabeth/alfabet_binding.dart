import 'package:get/get.dart';
import '../../controller/alfabeth/alfabeth_controller.dart';

class AlfabetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlfabetController>(() => AlfabetController());
  }
}