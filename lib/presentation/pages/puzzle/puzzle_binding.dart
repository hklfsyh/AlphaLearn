import 'package:alphalearn/presentation/controller/puzzle/puzzle_controller.dart';
import 'package:get/get.dart';

class PuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PuzzleController>(() => PuzzleController());
  }
}
