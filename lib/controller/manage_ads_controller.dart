import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/PlanModel.dart';
import 'package:agahi_app/screens/my_ads.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerAdsController extends GetxController {
  int? status;
  var listPlans = <PlanModel>[].obs;
  var selectedPlans = PlanModel().obs;
  var isLoadingPlans = false.obs;
  var isLoadingDelete = false.obs;
  var isLoadingForLink = false.obs;
  var priceValue = 0.obs;

  void getPlans() {
    isLoadingPlans(true);
    listPlans.clear();

    ApiProvider().getPlans().then((res) {
      List tmp = res.body;
      for (var element in tmp) {
        listPlans.add(PlanModel.fromJson(element));
      }
      listPlans.removeWhere((element) => element.name == "آگهی پولی");
      isLoadingPlans(false);
    });
  }

//limit past and need pay for ads
  void buyAds(int id) {
    isLoadingForLink(true);
    String plans = "4";

    /*  if (plans.isNotEmpty && plans.endsWith(',')) {
      plans = plans.substring(0, plans.length - 1);
    } */

    ApiProvider()
        .buyPlan(
      plansId: plans,
      id: id,
    )
        .then((res) {
      print(res);
      if (res.isOk) {
        isLoadingForLink(false);
        launchTheLinkUrl(res.body['data']["redirect_url"]);
      } else {
        isLoadingForLink(false);
        MySnackBar(
            res.body['message'] ?? 'مشکلی در پرداخت پیش آمده است',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
      /*  Get.back();
      Get.back(); */
    });
  }

  void buyPlans(int id) {
    isLoadingForLink(true);
    String plans = "";
    /*   listSelectedPlans.forEach((element) {
      plans = "$plans${element.id}, ";
    }); */
    plans = "${selectedPlans.value.id}, ";
    /*  if (plans.isNotEmpty && plans.endsWith(',')) {
      plans = plans.substring(0, plans.length - 1);
    } */

    ApiProvider()
        .buyPlan(
      plansId: plans,
      id: id,
    )
        .then((res) {
      print(res);
      if (res.isOk) {
        isLoadingForLink(false);
        launchTheLinkUrl(res.body['data']["redirect_url"]);
      } else {
        isLoadingForLink(false);
        MySnackBar(
            res.body['message'] ?? 'مشکلی در پرداخت پیش آمده است',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
      /*  Get.back();
      Get.back(); */
    });
  }

  Future<void> launchTheLinkUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  deleteAd(int id) {
    var maincontroller = Get.find<MainController>();
    isLoadingDelete(true);
    listPlans.clear();
    selectedPlans.value = PlanModel();

    ApiProvider().deleteAd(id).then((res) {
      /*    MySnackBar(
          res.body,
          CerrorColor,
          Icon(
            Icons.delete_sweep,
            color: CerrorColor,
          ));
 */
      maincontroller.listMyAds.value.removeWhere((element) => element.id == id);
      Get.back();
      Get.back();
      Get.back();
      Get.to(MyAdsScreen());

      isLoadingDelete(false);
    });
  }
}
