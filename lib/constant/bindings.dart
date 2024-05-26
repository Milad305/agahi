import 'package:agahi_app/controller/account_contoller.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/manage_ads_controller.dart';
import 'package:agahi_app/controller/setting_controller.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:get/get.dart';

import '../controller/payment_controller.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController());
    Get.put(SettingController());
    Get.put(LocationController());
    Get.put(CitySearchController());
    Get.put(AccountController());
    Get.put(ChatController());
    Get.put(AddAdsController());
    Get.put(ManagerAdsController());
    Get.put(PaymentController());
  }
}
