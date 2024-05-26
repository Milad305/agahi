import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/manage_ads_controller.dart';
import 'package:agahi_app/screens/edit_ads.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../widget/public_widget.dart';
import '../widget/widget.dart';

class ManageAdsScreen extends StatelessWidget {
  const ManageAdsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var manageadscontroller = Get.find<ManagerAdsController>();
    var maincontroller = Get.find<MainController>();
    return SafeArea(
        child: CustomScaffold(
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
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            // ignore: prefer_const_constructors
            const SizedBox(
              height: 20,
            ),
            maincontroller.adsModel.value.status == 2
                ? Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: Get.width,
                      margin: const EdgeInsets.only(right: 15, left: 15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "دلیل رد شدن آگهی: \n \n${maincontroller.adsModel.value.rejectReason!}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LikeAndViewCount(
                  count: maincontroller.adsModel.value
                      .likes, // Replace with your actual like count
                  label: 'لایک',
                ),
                SizedBox(width: 5),
                LikeAndViewCount(
                  count: maincontroller.adsModel.value
                      .view_count, // Replace with your actual view count
                  label: 'بازدید',
                ),
              ],
            ),
            maincontroller.adsModel.value.status == MyAdsStatus.accepted.index
                ? CategoryItem(
                    icon_right: Icon(Icons.show_chart_rounded,
                        color: Theme.of(context).highlightColor),
                    title_text: const Text('ارتقا آگهی و افزایش بازدید'),
                    func: () {
                      Get.toNamed('/plans');
                    },
                  )
                : const SizedBox(),

            CategoryItem(
              icon_right: Icon(Icons.visibility,
                  color: Theme.of(context).highlightColor),
              title_text: const Text('پیش نمایش'),
              func: () {
                //Get.toNamed('/showad');
                Get.to(ShowAdsScreen(
                    ads: maincontroller.adsModel.value, isPreview: true));
              },
            ),
            CategoryItem(
              icon_right:
                  Icon(Icons.edit, color: Theme.of(context).highlightColor),
              title_text: const Text('ویرایش آگهی'),
              func: () {
                Get.to(EditAdsScreen(ads: maincontroller.adsModel.value));
              },
            ),
            CategoryItem(
              icon_right:
                  Icon(Icons.delete, color: Theme.of(context).highlightColor),
              title_text: const Text('حذف'),
              func: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogueCancelMassage(
                      text: 'از حذف آگهی اطمینان دارید ؟',
                      deletefunc: () async {
                        await manageadscontroller
                            .deleteAd(maincontroller.adsModel.value.id!);
                      },
                    );
                  },
                );
              },
            ),

            maincontroller.adsModel.value.status == MyAdsStatus.pending.index
                ? CategoryItem(
                    icon_right: Icon(Icons.paid_rounded,
                        color: Theme.of(context).highlightColor),
                    title_text: const Text('پرداخت و انتشار آگهی'),
                    func: () {
                      Get.find<ManagerAdsController>()
                          .buyAds(maincontroller.adsModel.value.id!);
                      Get.find<ManagerAdsController>().update();
                    },
                  )
                : const SizedBox(),
          ],
        ),
      ),
    ));
  }
}

class LikeAndViewCount extends StatelessWidget {
  final int? count;
  final String label;

  const LikeAndViewCount({
    Key? key,
    required this.count,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .45,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
          Text(
            '$count',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Icon(
            label == 'لایک' ? Icons.thumb_up : Icons.remove_red_eye,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
