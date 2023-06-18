import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FasilitasController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static FasilitasController get to => Get.find();

  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {});
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
