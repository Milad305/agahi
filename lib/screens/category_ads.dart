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

class CatAdsPage extends GetView<MainController> {
  final maincontroller = Get.find<MainController>();
  final int catIndex;
  final String catTitle;
  CatAdsPage({required this.catIndex, required this.catTitle, super.key}) {
    maincontroller.getMyAdsFitlerByCategory(catIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScaffold(
          appBar: AppBar(
            title: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                catTitle,
                style: const TextStyle(fontSize: 14),
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
                  child: maincontroller.isLoadingAds.value
                      ? const Center(
                          child: Text("... در حال دریافت آگهی ها"),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              /*      Obx(() {
                                return Get.find<MainController>()
                                            .isinternet
                                            .value ==
                                        false
                                    ? OflineMessage()
                                    : Container();
                              }),*/
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    if (!maincontroller.hasFilter.value) {
                                      maincontroller.fromPriceController
                                          .clear();
                                      maincontroller.toPriceController.clear();
                                    }

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: SizedBox(
                                                height: Get.height * .24,
                                                width: Get.width,
                                                child: Column(
                                                  children: [
                                                    const Text("فیلترها"),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(" قیمت"),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 45,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 17,
                                                                      right: 4),
                                                              //from price
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    maincontroller
                                                                        .fromPriceController,
                                                                keyboardType:
                                                                    const TextInputType
                                                                        .numberWithOptions(
                                                                  signed: false,
                                                                  decimal:
                                                                      false,
                                                                ),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'[0-9]')),
                                                                ],
                                                                decoration: const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "از قیمت"),
                                                                onFieldSubmitted: ((value) =>
                                                                    maincontroller
                                                                        .fromPriceController
                                                                        .text = value),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                              height: 45,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 17,
                                                                      right: 4),
                                                              //to price
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    maincontroller
                                                                        .toPriceController,
                                                                keyboardType:
                                                                    const TextInputType
                                                                        .numberWithOptions(
                                                                  signed: false,
                                                                  decimal:
                                                                      false,
                                                                ),
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(RegExp(
                                                                          r'[0-9]')),
                                                                ],
                                                                decoration: const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        "تا قیمت"),
                                                                onFieldSubmitted: ((value) =>
                                                                    maincontroller
                                                                        .toPriceController
                                                                        .text = value),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                            'آگهی های عکس دار'),
                                                        const Spacer(),
                                                        SizedBox(width: 10),
                                                        Obx(
                                                          () => Checkbox(
                                                            value: maincontroller
                                                                .isImageFilter
                                                                .value,
                                                            onChanged: (value) {
                                                              maincontroller
                                                                  .isImageFilter
                                                                  .value = value!;
                                                              // You can perform additional actions here based on the checkbox state.
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Cprimary,
                                                                  foregroundColor:
                                                                      Cwhite),
                                                          onPressed: () {
                                                            maincontroller
                                                                    .isImageFiltered
                                                                    .value =
                                                                maincontroller
                                                                    .isImageFilter
                                                                    .value;
                                                            maincontroller
                                                                .hasFilter(
                                                                    true);
                                                            maincontroller
                                                                        .fromPriceController
                                                                        .text !=
                                                                    ''
                                                                ? maincontroller
                                                                        .fromPriceFilter
                                                                        .value =
                                                                    int.parse(maincontroller
                                                                        .fromPriceController
                                                                        .text)
                                                                : null;
                                                            maincontroller
                                                                        .toPriceController
                                                                        .text !=
                                                                    ''
                                                                ? maincontroller
                                                                        .toPriceFilter
                                                                        .value =
                                                                    int.parse(maincontroller
                                                                        .toPriceController
                                                                        .text)
                                                                : null;
                                                            maincontroller
                                                                .filterCatAds();
                                                          },
                                                          child: const Text(
                                                              'اعمال فیلتر'),
                                                        ),
                                                        const SizedBox(
                                                          width: 30,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Cprimary,
                                                                  foregroundColor:
                                                                      Cwhite),
                                                          onPressed: () {
                                                            maincontroller
                                                                .hasFilter(
                                                                    false);
                                                            maincontroller
                                                                .fromPriceFilter
                                                                .value = -1;

                                                            maincontroller
                                                                    .toPriceFilter
                                                                    .value =
                                                                9999999999999999;
                                                            maincontroller
                                                                .isImageFiltered(
                                                                    false);
                                                          },
                                                          child: const Text(
                                                              'حذف فیلتر'),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 36,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Cprimary),
                                    child: const Center(
                                      child: Text(
                                        "فیلتر",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                                    child: maincontroller.catListAds.isEmpty
                                        ? const Center(
                                            child: Text('موردی یافت نشد'),
                                          )
                                        : Column(
                                            children: [
                                              Obx(() {
                                                print(maincontroller
                                                        .hasFilter.value
                                                        .toString() +
                                                    ":" +
                                                    maincontroller
                                                        .isImageFiltered.value
                                                        .toString());
                                                return maincontroller
                                                            .hasFilter.value ||
                                                        maincontroller
                                                            .isImageFiltered
                                                            .value
                                                    ? Expanded(
/*                                                       height: Get.height,
                                                      width: Get.width, */
                                                        child: ListView.builder(
                                                          itemCount: maincontroller
                                                              .filteredcatListAds
                                                              .length,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 30),
                                                          itemBuilder:
                                                              (context, index) {
                                                            /*        print(maincontroller
                                                                                                  .catListAds[index].createdAt); */
                                                            return BoxAgahi(
                                                              isLadder:
                                                                  maincontroller
                                                                      .listAds[
                                                                          index]
                                                                      .ladder!,
                                                              title: maincontroller
                                                                      .filteredcatListAds[
                                                                          index]
                                                                      .title ??
                                                                  '',
                                                              text_dovom: maincontroller
                                                                  .filteredcatListAds[
                                                                      index]
                                                                  .getCityName(),
                                                              text_qeymat: maincontroller
                                                                      .filteredcatListAds[
                                                                          index]
                                                                      .getprice() ??
                                                                  '',
                                                              text_date: maincontroller
                                                                  .filteredcatListAds[
                                                                      index]
                                                                  .ladder_time
                                                                  .toString()
                                                                  .get_created_at(),
                                                              image: maincontroller
                                                                  .filteredcatListAds[
                                                                      index]
                                                                  .getPreviewImage(),
                                                              isForce:
                                                                  maincontroller
                                                                      .filteredcatListAds[
                                                                          index]
                                                                      .isForce,
                                                              func: () {
                                                                maincontroller.adsModel(
                                                                    maincontroller
                                                                            .filteredcatListAds[
                                                                        index]);
                                                                // Get.toNamed('/showad');
                                                                Get.to(ShowAdsScreen(
                                                                    ads: maincontroller
                                                                            .filteredcatListAds[
                                                                        index]));
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : Expanded(
                                                        /* height: Get.height,
                                                      width: Get.width, */
                                                        child: ListView.builder(
                                                          itemCount:
                                                              maincontroller
                                                                  .catListAds
                                                                  .length,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 30),
                                                          itemBuilder:
                                                              (context, index) {
                                                            /*        print(maincontroller
                                                                                                    .catListAds[index].createdAt); */
                                                            return BoxAgahi(
                                                              isLadder:
                                                                  maincontroller
                                                                      .listAds[
                                                                          index]
                                                                      .ladder!,
                                                              title: maincontroller
                                                                      .catListAds[
                                                                          index]
                                                                      .title ??
                                                                  '',
                                                              text_dovom:
                                                                  maincontroller
                                                                      .catListAds[
                                                                          index]
                                                                      .getCityName(),
                                                              text_qeymat: maincontroller
                                                                      .catListAds[
                                                                          index]
                                                                      .getprice() ??
                                                                  '',
                                                              text_date: maincontroller
                                                                  .catListAds[
                                                                      index]
                                                                  .ladder_time
                                                                  .toString()
                                                                  .get_created_at(),
                                                              image: maincontroller
                                                                  .catListAds[
                                                                      index]
                                                                  .getPreviewImage(),
                                                              isForce:
                                                                  maincontroller
                                                                      .catListAds[
                                                                          index]
                                                                      .isForce,
                                                              func: () {
                                                                maincontroller.adsModel(
                                                                    maincontroller
                                                                            .catListAds[
                                                                        index]);
                                                                // Get.toNamed('/showad');
                                                                Get.to(ShowAdsScreen(
                                                                    ads: maincontroller
                                                                            .catListAds[
                                                                        index]));
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                              })
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
