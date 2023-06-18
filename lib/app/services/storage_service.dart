import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  // Initial
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    await GetStorage().write(key, value);
  }

  dynamic read(String key) {
    return GetStorage().read(key);
  }

  Future<void> remove(String key) async {
    await GetStorage().remove(key);
  }

  Future<void> erase() async {
    await GetStorage().erase();
  }
}
