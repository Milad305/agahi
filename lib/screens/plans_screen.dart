import 'package:agahi_app/controller/manage_ads_controller.dart';
import 'package:agahi_app/models/PlanModel.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../controller/main_controller.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    var manageadscontroller = Get.find<ManagerAdsController>();
    manageadscontroller.getPlans();
    manageadscontroller.priceValue(0);
    manageadscontroller.selectedPlans(PlanModel());
    manageadscontroller.isLoadingForLink(false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  maincontroller.adsModel.value.title!,
                  style: const TextStyle(fontSize: 17),
                )
              ],
            ),
            backgroundColor: Cprimary,
            leading: IconButton(
                highlightColor: Cwhite.withOpacity(.5),
                splashRadius: 20,
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back))),
        body: Obx(() => manageadscontroller.isLoadingPlans.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Cprimary,
                  strokeWidth: 1.5,
                ),
              )
            : SizedBox(
                width: Get.width,
                height: Get.height,
                child: Column(
                  children: [
                    /*     Obx(
                 () {
                  return Get.find<MainController>().isinternet.value == false ? OflineMessage() :Container();
                }
              ),*/
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemBuilder: (context, index) {
                            PlanModel pm = manageadscontroller.listPlans[index];
                            return PlanCard(
                              pm: pm,
                            );
                          },
                          itemCount: manageadscontroller.listPlans.length),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight),
                      width: Get.width,
                      height: 50,
                      child: Obx(() => Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  'قابل پرداخت:${manageadscontroller.priceValue} تومان'),
                              const Spacer(),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      minimumSize: const Size(120, 45),
                                      backgroundColor: Cprimary,
                                      foregroundColor: Cwhite,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    if (manageadscontroller
                                            .isLoadingForLink.isFalse &&
                                        manageadscontroller
                                            .selectedPlans.value != PlanModel()) {
                                      manageadscontroller.buyPlans(
                                          maincontroller.adsModel.value.id!);
                                    }
                                  },
                                  child: Obx(() =>
                                      manageadscontroller.isLoadingForLink.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: Cwhite,
                                                strokeWidth: 1.5,
                                              ),
                                            )
                                          : const Text('پرداخت'))),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              )),
      ),
    );
  }
}
