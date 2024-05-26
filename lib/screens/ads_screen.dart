import 'dart:async';

import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/screens/search_screen.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:agahi_app/utils/contect_utility.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../widget/SmallItemCategory.dart';
import '../widget/widget.dart';

// ignore: must_be_immutable
class AdsScreen extends StatelessWidget {
  AdsScreen({super.key});
  var maincontroller = Get.find<MainController>();
  var citysearchcontroller = Get.find<CitySearchController>();
  @override
  Widget build(BuildContext context) {
    /*   if (maincontroller.uniloaded.value == false) {
      UniLinksService.init();
    } */
    /*maincontroller.isAppLoaded(true);

    maincontroller.adsModel.value != AdsModel() &&
            maincontroller.deeplinking.value
        ? Get.to(() => ShowAdsScreen(
              ads: maincontroller.adsModel.value,
            ))
        : null;*/

    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            color: Theme.of(context).primaryColorLight,
            height: 126,
            width: Get.width,
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColorLight,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.only(right: 10, left: 5),
                    margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      boxShadow: [bs010],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.search,
                                color: Theme.of(context).highlightColor,
                              ),
                              onTap: () {
                                maincontroller.getAds();
                              },
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.to(() => SearchAds()),
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "جستجو ...",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ), /*TextField(
                              onSubmitted: (value) {
                                maincontroller.getAds();
                              },
                              controller: maincontroller.textFieldSearchAds,
                              onChanged: (value) {
                                if (value != '') {
                                  maincontroller.isShowClearButtonAds(true);
                                } else {
                                  maincontroller.isShowClearButtonAds(false);
                                }
                              },
                              showCursor: false,
                              style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontFamily: 'iransans',
                                  fontSize: 14),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontFamily: 'iransans', fontSize: 14),
                                  hintText: 'جستجو...'),
                            ),*/
                            ),
                            Obx(() => SizedBox(
                                  child: maincontroller
                                          .isShowClearButtonAds.value
                                      ? IconButton(
                                          splashRadius: 20,
                                          onPressed: () {
                                            maincontroller
                                                .textFieldSearchAds.text = '';
                                            maincontroller
                                                .isShowClearButtonAds(false);

                                            maincontroller.getAds();
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Theme.of(context)
                                                .cardColor
                                                .withOpacity(.5),
                                          ))
                                      : const SizedBox(),
                                )),
                            VerticalDivider(
                              width: 1,
                              indent: 15,
                              endIndent: 15,
                              color: Theme.of(context).highlightColor,
                              thickness: 1,
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(right: 5),
                                    textStyle: const TextStyle(
                                        fontFamily: 'iransans', fontSize: 13),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor:
                                        Theme.of(context).cardColor),
                                onPressed: () {
                                  citysearchcontroller.isSearchMode(false);
                                  citysearchcontroller.textFieldSearchCity
                                      .clear();
                                  Get.toNamed('citysearch');
                                },
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Obx(() => Text(citysearchcontroller
                                                    .listSelectedCities
                                                    .length ==
                                                1
                                            ? citysearchcontroller
                                                .listSelectedCities[0].name!
                                            : '${citysearchcontroller.listSelectedCities.length}شهر')),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.location_on,
                                        color: Theme.of(context).highlightColor,
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        )),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Obx(() => maincontroller.isLoadingCategory.value
                      ? Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 1.5, color: Cprimary),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 40,
                          child: Obx(() {
                            return Container(
                              width: Get.width,
                              child: ListView.builder(
                                itemCount: maincontroller.listCategory.length,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return ItemSmallCategory(
                                      controller: citysearchcontroller,
                                      index: index,
                                      categorymodel:
                                          maincontroller.listCategory[index]);
                                },
                              ),
                            );
                          }),
                        )),
                )
              ],
            ),
          ),
          Expanded(
              child: Obx(() => maincontroller.isLoadingAds.value
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Cprimary,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(
                          const Duration(milliseconds: 200),
                          () {
                            Get.find<CitySearchController>()
                                        .selectedcat
                                        .value ==
                                    -1
                                ? maincontroller.getAds()
                                : maincontroller.getMyAdsFitlerByCategorymain(
                                    maincontroller.currentCat.value);
                          },
                        );
                      },
                      child: maincontroller.listAds.isEmpty
                          ? const Center(
                              child: Text('موردی یافت نشد'),
                            )
                          : ListView.builder(
                              itemCount: maincontroller.listAds.length,
                              padding: const EdgeInsets.only(bottom: 30),
                              itemBuilder: (context, index) {
                                print(maincontroller.listAds[index].createdAt);
                                return BoxAgahi(
                                  isLadder:
                                      maincontroller.listAds[index].ladder!,
                                  title:
                                      maincontroller.listAds[index].title ?? '',
                                  text_dovom: maincontroller.listAds[index]
                                      .getCityName(),
                                  text_qeymat: maincontroller.listAds[index]
                                          .getprice() ??
                                      '',
                                  text_date: maincontroller
                                      .listAds[index].ladder_time
                                      .toString()
                                      .get_created_at(),
                                  image: maincontroller.listAds[index]
                                      .getPreviewImage(),
                                  isForce:
                                      maincontroller.listAds[index].isForce,
                                  func: () {
                                    maincontroller.adsModel(
                                        maincontroller.listAds[index]);
                                    // Get.toNamed('/showad');
                                    Get.to(ShowAdsScreen(
                                        ads: maincontroller.listAds[index]));
                                  },
                                );
                              },
                            ),
                    ))),
        ],
      ),
    );
  }
}
