import 'package:get/get.dart';

import 'controller/auth_controller.dart';
import 'controller/file_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put<FileController>(FileController());
  }
}
