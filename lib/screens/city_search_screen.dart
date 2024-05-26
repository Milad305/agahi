import 'dart:async';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../widget/BottomAppbarCitySearch.dart';
import '../widget/CitySearch_city_Widget.dart';
import '../widget/CitySearch_state_Widget.dart';

class CitySearchScreen extends StatelessWidget {
  const CitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var citysearchcontroller = Get.find<CitySearchController>();
    citysearchcontroller.getStates();

    //citysearchcontroller.getSelectedCities();
    Timer(Duration.zero, () {
      unFocus();
    });
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        if (citysearchcontroller.showCities.value) {
          citysearchcontroller.showCities(false);
          return Future(() => false);
        } else {
          if (citysearchcontroller.listSelectedCities.isEmpty) {
            CityModel cm = GetStorage('agahi').read('city');
            citysearchcontroller.listSelectedCities.add(cm);
          }
          var cit = GetStorage('agahi').read('city');
          CityModel cm = CityModel.fromJson(cit);
          GetStorage('agahi')
              .write('filter', citysearchcontroller.listSelectedCities.value);
          Get.find<MainController>().getAds();
          Get.back();
          return Future(() => true);
        }
      },
      child: Obx(() => CustomScaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColorLight,
                toolbarHeight: 50,
                bottom: citysearchcontroller.showCities.value ||
                        citysearchcontroller.listSelectedCities.isEmpty ||
                        citysearchcontroller.isSearchMode.value
                    ? null
                    : const BottomAppbarCitySearch(),
                actions: [
                  IconButton(
                      highlightColor: Colors.white.withOpacity(.2),
                      splashRadius: 20,
                      onPressed: () {
                        citysearchcontroller.listSelectedCities.clear();
                        GetStorage('agahi').remove('filter');
                        Get.find<MainController>().getAds();
                      },
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: Theme.of(context).highlightColor,
                      ))
                ],
                title: SizedBox(
                  width: Get.width,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                          child: TextField(
                              autofocus: true,
                              showCursor: false,
                              onChanged: (value) {
                                citysearchcontroller.listTmpSearch.clear();
                                if (value != '') {
                                  citysearchcontroller
                                      .isShowClearButtonCity(true);
                                  citysearchcontroller.isSearchMode(true);
                                  Timer(Duration.zero, () {
                                    for (var element
                                        in citysearchcontroller.listAllCities) {
                                      if (value == element.name) {
                                        citysearchcontroller.listTmpSearch
                                            .add(element);
                                      }
                                    }
                                  });
                                } else {
                                  citysearchcontroller
                                      .isShowClearButtonCity(false);
                                  citysearchcontroller.isSearchMode(false);
                                }
                              },
                              controller:
                                  citysearchcontroller.textFieldSearchCity,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintTextDirection: TextDirection.rtl,
                                  hintText: 'جستجو شهر'))),
                      Obx(() => SizedBox(
                            child: citysearchcontroller
                                    .isShowClearButtonCity.value
                                ? IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      citysearchcontroller
                                          .textFieldSearchCity.text = '';
                                      citysearchcontroller
                                          .isShowClearButtonCity(false);
                                      citysearchcontroller.isSearchMode(false);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(.5),
                                    ))
                                : const SizedBox(),
                          )),
                    ],
                  ),
                ),
                leading: IconButton(
                    highlightColor: Colors.white.withOpacity(.2),
                    splashRadius: 20,
                    onPressed: () {
                      if (citysearchcontroller.showCities.value) {
                        citysearchcontroller.showCities(false);
                      } else {
                        Get.back();
                      }
                    },
                    icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).highlightColor))),
            body: Column(
              children: [
                /*  Obx(() {
                  return Get.find<MainController>().isinternet.value == false
                      ? OflineMessage()
                      : Container();
                }),*/
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Obx(() => citysearchcontroller
                                .isLoadingCities.value ||
                            citysearchcontroller.isLoadingStates.value
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Cprimary,
                            ),
                          )
                        : citysearchcontroller.isSearchMode.value
                            ? citysearchcontroller.listTmpSearch.isEmpty
                                ? const SizedBox()
                                : ListView.builder(
                                    itemCount: citysearchcontroller
                                        .listTmpSearch.length,
                                    itemBuilder: (context, index) {
                                      return CityWidget(
                                          citymodel: citysearchcontroller
                                              .listTmpSearch[index],
                                          index: index);
                                    },
                                  )
                            : citysearchcontroller.showCities.value
                                ? CityListView(
                                    citysearchcontroller: citysearchcontroller)
                                : StateListView(
                                    citysearchcontroller:
                                        citysearchcontroller)),
                  ),
                ),
                citysearchcontroller.showCities.value
                    ? TextButton(
                        onPressed: () {
                          citysearchcontroller.listCities.forEach((element) {
                            citysearchcontroller.listSelectedCities
                                .add(element);
                          });
                          final ids = citysearchcontroller.listSelectedCities
                              .map((e) => e.id)
                              .toSet();
                          citysearchcontroller.listSelectedCities
                              .retainWhere((x) => ids.remove(x.id));
                          citysearchcontroller.listSelectedCities.toList();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Cprimary,
                            foregroundColor: Cwhite,
                            minimumSize: Size(Get.width, 50)),
                        child: const Text('انتخاب همه'))
                    : TextButton(
                        onPressed: () {
                          if (citysearchcontroller.listSelectedCities.isEmpty) {
                            CityModel cm = GetStorage('agahi').read('city');
                            citysearchcontroller.listSelectedCities.add(cm);
                          }
                          var cit = GetStorage('agahi').read('city');
                          CityModel cm = CityModel.fromJson(cit);
                          GetStorage('agahi').write('filter',
                              citysearchcontroller.listSelectedCities.value);
                          Get.find<MainController>().getAds();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Cprimary,
                            foregroundColor: Cwhite,
                            minimumSize: Size(Get.width, 50)),
                        child: const Text('تایید'))
              ],
            ),
          )),
    ));
  }
}

class StateListView extends StatelessWidget {
  const StateListView({
    super.key,
    required this.citysearchcontroller,
  });

  final CitySearchController citysearchcontroller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: citysearchcontroller.listStates.length,
      itemBuilder: (context, index) {
        return StateWidget(
            index: index, citysearchcontroller: citysearchcontroller);
      },
    );
  }
}

class CityListView extends StatelessWidget {
  const CityListView({
    super.key,
    required this.citysearchcontroller,
  });

  final CitySearchController citysearchcontroller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: citysearchcontroller.listCities.length,
      itemBuilder: (context, index) {
        return CityWidget(
          index: index,
          citymodel: citysearchcontroller.listCities[index],
        );
      },
    );
  }
}
