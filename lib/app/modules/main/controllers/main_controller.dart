import 'dart:math';

import 'package:get/get.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  RxInt pageIndex = 0.obs;

  Rx<String> refreshKey = ''.obs;

  String generateRefreshKey(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    refreshKey.value = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return refreshKey.value;
  }
}
