// ignore_for_file: non_constant_identifier_names

import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OwnerAdsScreen extends GetView<MainController> {
  OwnerAdsScreen({super.key}) {
    // maincontroller.getAdsByOwner();
  }

  final maincontroller = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScaffold(
          appBar: AppBar(
            title: const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "آگهی های کاربر",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Obx(() {
                return Container(
                  height: Get.height,
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: maincontroller.isLoadingOwnerAds.value
                      ? const Center(
                          child: Text("... در حال دریافت آگهی ها"),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Expanded(
                                child: RefreshIndicator(
                                    onRefresh: () {
                                      return Future.delayed(
                                        const Duration(milliseconds: 200),
                                        () {
                                          //  maincontroller.getAds(); TODO::get ads by cat
                                        },
                                      );
                                    },
                                    child: maincontroller.listOwenerAds.isEmpty
                                        ? const Center(
                                            child: Text('موردی یافت نشد'),
                                          )
                                        : Column(
                                            children: [
                                              Expanded(
                                                /* height: Get.height,
                                                      width: Get.width, */
                                                child: ListView.builder(
                                                  itemCount: maincontroller
                                                      .listOwenerAds.length,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 30),
                                                  itemBuilder:
                                                      (context, index) {
                                                    /*        print(maincontroller
                                                                                                    .listOwenerAds[index].createdAt); */
                                                    return BoxAgahi(
                                                      isLadder: maincontroller
                                                          .listAds[index]
                                                          .ladder!,
                                                      title: maincontroller
                                                              .listOwenerAds[
                                                                  index]
                                                              .title ??
                                                          '',
                                                      text_dovom: maincontroller
                                                          .listOwenerAds[index]
                                                          .getCityName(),
                                                      text_qeymat: maincontroller
                                                              .listOwenerAds[
                                                                  index]
                                                              .getprice() ??
                                                          '',
                                                      text_date: maincontroller
                                                          .listOwenerAds[index]
                                                          .ladder_time
                                                          .toString()
                                                          .get_created_at(),
                                                      image: maincontroller
                                                          .listOwenerAds[index]
                                                          .getPreviewImage(),
                                                      isForce: maincontroller
                                                          .listOwenerAds[index]
                                                          .isForce,
                                                      func: () {
                                                        maincontroller.adsModel(
                                                            maincontroller
                                                                    .listOwenerAds[
                                                                index]);
                                                        // Get.toNamed('/showad');
                                                        Get.to(ShowAdsScreen(
                                                            ads: maincontroller
                                                                    .listOwenerAds[
                                                                index]));
                                                      },
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          )),
                              )
                            ]),
                );
              }),
            ),
          )),
    );
  }
}
