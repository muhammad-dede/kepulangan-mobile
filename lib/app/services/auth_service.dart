import 'package:get/get.dart';
import 'package:kepulangan/app/data/models/user.dart';
import 'package:kepulangan/app/services/base_client.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  Rx<User> auth = User().obs;
  RxBool isAdmin = false.obs;

  Future<AuthService> init() async {
    await me();
    return this;
  }

  Future<void> me() async {
    final response = await BaseClient().get('/api/auth/me');
    response.fold((l) {
      auth.value = User();
    }, (r) {
      auth.value = User.fromJson(r['data']);
    });
    isAdmin.value = auth.value.role.toString() == "Admin" ? true : false;
  }
}
