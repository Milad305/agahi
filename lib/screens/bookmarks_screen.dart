import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/account_contoller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../widget/widget.dart';
import 'show_ads_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var accountcontroller = Get.find<AccountController>();
    var maincontroller = Get.find<MainController>();
    accountcontroller.getBookmarks();
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Obx(() => accountcontroller.isLoadingBookmars.value
          ? Center(
              child:
                  CircularProgressIndicator(strokeWidth: 1.5, color: Cprimary),
            )
          : accountcontroller.listBookmarks.isEmpty
              ? const Center(
                  child: Text('اطلاعاتی برای نمایش وجود ندارد'),
                )
              : ListView.builder(
                  itemCount: accountcontroller.listBookmarks.length,
                  itemBuilder: (context, index) {
                    return BoxAgahi(
                        isLadder: maincontroller.listAds[index].ladder!,
                        func: () {
                          maincontroller.adsModel(
                              accountcontroller.listBookmarks[index].ads);
                          //Get.toNamed('/showad');
                          Get.to(ShowAdsScreen(
                              ads: maincontroller.listAds[index]));
                        },
                        title:
                            accountcontroller.listBookmarks[index].ads?.title ??
                                '',
                        text_dovom: '',
                        text_qeymat: accountcontroller.listBookmarks[index].ads
                                ?.getprice() ??
                            '',
                        text_date: accountcontroller
                                .listBookmarks[index].ads?.ladder_time
                                .toString()
                                .get_created_at() ??
                            '',
                        image: accountcontroller.listBookmarks[index].ads
                            ?.getPreviewImage());
                  },
                )),
    );
  }
}
