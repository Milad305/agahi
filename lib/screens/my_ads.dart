import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../widget/widget.dart';

class MyAdsScreen extends StatelessWidget {
  var maincontroller = Get.find<MainController>();
  MyAdsScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await maincontroller.getMyAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: Column(children: [
        /*  Obx(() {
            return Get.find<MainController>().isinternet.value == false
                ? OflineMessage()
                : Container();
          }),*/
          CustomAppBar(
            bg_color: Cprimary,
            show_back: true,
            show_title: true,
            title: "آگهی های من",
            title_icon: Icon(
              Icons.library_books,
              color: Cwhite,
              size: 20,
            ),
          ),
          Expanded(
              child: Obx(() => maincontroller.isLoadingMyAds.value
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Cprimary,
                      ),
                    )
                  : maincontroller.listMyAds.isEmpty
                      ? const Center(
                          child: Text('آگهی ثبت نکرده اید'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: maincontroller.listMyAds.length,
                          itemBuilder: (context, index) {
                            AdsModel ad = maincontroller.listMyAds[index];
                            return BoxAgahi(
                              isLadder: maincontroller.listMyAds[index].ladder!,
                              func: () {
                                maincontroller.adsModel(ad);
                                Get.toNamed('/managead');
                              },
                              statusMessage: ad.rejectReason,
                              myadsstatus: ad.status,
                              title: ad.title ?? '',
                              text_dovom: '',
                              text_qeymat: ad.getprice() ?? '',
                              text_date:
                                  ad.ladder_time.toString().get_created_at(),
                              image: ad.getPreviewImage(),
                            );
                          },
                        )))
        ]),
      ),
    );
  }
}
