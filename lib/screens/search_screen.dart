import 'dart:async';
import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:agahi_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class SearchAds extends GetView<MainController> {
  SearchAds({Key? key}) : super(key: key) {
    Get.put(MainController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.readHistory();
      controller.searchAds.clear();
    });
  }

  /*List defaultSports = [
    {
      "title": "دوچرخه سواری",
    },
    {
      "id": 680,
      "met": 3.5,
      "title": "پیاده روی",
      "description":
          "پیاده روی در زمین صاف یا سفت با سرعت متوسط 4.5 تا 5 کیلومتر در ساعت ",
      "steps": null,
      "img": "https:\/\/cdn.salamatiman.ir\/images\/exercises\/680.jpg",
      "images": "https:\/\/cdn.salamatiman.ir\/images\/exercises\/680.jpg",
      "show_to_user": null,
      "video": null,
      "category": 17,
      "minutes": 30,
      "difficulty": null,
      "uid": null
    },
    {
      "id": 124,
      "met": 2.3,
      "title": "فعالیت های خانگی",
      "description": "جارو کردن آهسته و با تحرک کم",
      "steps": null,
      "img": "https:\/\/cdn.salamatiman.ir\/images\/exercises\/124.jpg",
      "images": "https:\/\/cdn.salamatiman.ir\/images\/exercises\/124.jpg",
      "show_to_user": null,
      "video": null,
      "category": 5,
      "minutes": 30,
      "difficulty": null,
      "uid": null
    }
  ];*/

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ), */
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        autofocus: true,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "جستجو...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          suffixIconConstraints: const BoxConstraints(
                            maxHeight: 50,
                          ),
                          suffixIcon: GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.only(right: 7, left: 5),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                Icons.search,
                                size: 21,
                              ),
                            ),
                            onTap: () {
                              controller.adsSearch(
                                controller.searchText.value.toString(),
                              );
                            },
                          ),
                        ),
                        onChanged: (String val) {
                          controller.searchText(val.toString());
                        },
                      ),
                    ),
                  ),
                  Obx(() {
                    return controller.searchHistory.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 7),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    controller.searchHistory.value.map<Widget>(
                                  (item) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.adsSearch(item['title']);
                                        },
                                        child: Chip(
                                          label: Text(
                                            item['title'],
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            color: Colors.grey,
                                          ),
                                          onDeleted: () {
                                            controller
                                                .deleteHistory(item['title']);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          )
                        : Container();
                  })
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingAds.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(0, 0, 0, 0.451),
                    ),
                  );
                }
                if (controller.isLoadingAds.value == false &&
                    controller.searchAds.isEmpty) {
                  return Container();
                }
                final sport = controller.searchAds.value;
                return ListView.builder(
                  itemCount: controller.searchAds.length,
                  padding: const EdgeInsets.only(bottom: 30),
                  itemBuilder: (context, index) {
                    print(controller.searchAds[index].createdAt);
                    return BoxAgahi(
                      isLadder: controller.searchAds[index].ladder!,
                      title: controller.searchAds[index].title ?? '',
                      text_dovom: controller.searchAds[index].getCityName(),
                      text_qeymat: controller.searchAds[index].getprice() ?? '',
                      text_date: controller.searchAds[index].ladder_time
                          .toString()
                          .get_created_at(),
                      image: controller.searchAds[index].getPreviewImage(),
                      isForce: controller.searchAds[index].isForce,
                      func: () {
                        controller.adsModel(controller.searchAds[index]);
                        // Get.toNamed('/showad');
                        Get.to(ShowAdsScreen(ads: controller.searchAds[index]));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
