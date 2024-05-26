import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../widget/public_widget.dart';
import '../widget/widget.dart';
import 'show_ads_screen.dart';

class RecentScreen extends StatelessWidget {
  const RecentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var settingcontroller = Get.find<SettingController>();
    settingcontroller.getRecentView();
    return SafeArea(
        child: CustomScaffold(
      body: Column(
        children: [
          CustomAppBar(
            bg_color: Cprimary,
            show_back: true,
            show_title: true,
            title: "بازدیدهای اخیر",
            title_icon: Icon(
              Icons.timelapse,
              color: Cwhite,
              size: 20,
            ),
          ),
          Expanded(
              child: Obx(() => settingcontroller.isLoadingRecentView.value
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Cprimary,
                      ),
                    )
                  : settingcontroller.listRecentViews.isEmpty
                      ? const Center(
                          child: Text('اطلاعاتی یافت نشد'),
                        )
                      : ListView.builder(
                          itemCount: settingcontroller.listRecentViews.length,
                          padding: const EdgeInsets.only(bottom: 30),
                          itemBuilder: (context, index) {
                            return BoxAgahi(
                              isLadder: settingcontroller
                                  .listRecentViews[index].ladder!,
                              title: settingcontroller
                                      .listRecentViews[index].title ??
                                  '',
                              text_dovom: '',
                              text_qeymat: settingcontroller
                                      .listRecentViews[index]
                                      .getprice() ??
                                  '',
                              text_date: settingcontroller
                                  .listRecentViews[index].ladder_time
                                  .toString()
                                  .get_created_at(),
                              image: settingcontroller.listRecentViews[index]
                                  .getPreviewImage(),
                              func: () {
                                Get.find<MainController>().adsModel(
                                    settingcontroller.listRecentViews[index]);
                                //Get.toNamed('/showad');
                                Get.to(ShowAdsScreen(
                                    ads: settingcontroller
                                        .listRecentViews[index]));
                              },
                            );
                          },
                        ))),
        ],
      ),
    ));
  }
}
