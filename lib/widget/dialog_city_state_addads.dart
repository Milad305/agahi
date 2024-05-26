import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/models/DistrictModel.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DialogCityStateAddAds extends StatelessWidget {
  const DialogCityStateAddAds({super.key});

  @override
  Widget build(BuildContext context) {
    var addadascontroller = Get.find<AddAdsController>();
    return CustomScaffold(
      appBar: AppBar(
        title: Row(
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'انتخاب محدوده',
              style: TextStyle(color: Cwhite, fontSize: 18),
            ),
          ],
        ),
        backgroundColor: Cprimary,
        foregroundColor: Cwhite,
        leading: IconButton(
            highlightColor: Cwhite.withOpacity(.5),
            splashRadius: 20,
            onPressed: () async {
              addadascontroller.isShowCity.value
                  ? addadascontroller.isShowCity(false)
                  : Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(() => addadascontroller.refreshList.value
              ? const SizedBox()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Divider(
                                height: 2,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'انتخاب استان و شهر',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: Get.width,
                        height: Get.height * .85,
                        child: ListView.builder(
                          itemCount: addadascontroller.isShowDistrict.value
                              ? addadascontroller
                                  .selectedCity.value.districts!.length
                              : addadascontroller.isShowCity.value
                                  ? addadascontroller.listCities.length
                                  : addadascontroller.listStates.length,
                          itemBuilder: (context, index) {
                            if (addadascontroller.isShowDistrict.value) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.1))),
                                  child: ListTile(
                                    title: Text(addadascontroller.selectedCity
                                        .value.districts![index].name!),
                                    onTap: () {
                                      addadascontroller.selectedDistrict(
                                          addadascontroller
                                              .listDistricts[index]);
                                      GetStorage('agahi').write(
                                          'selectedDistrict',
                                          addadascontroller
                                              .listDistricts[index]);

                                      addadascontroller.saveData();
                                      Get.back();
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.1))),
                                  child: ListTile(
                                    title: Text(
                                        addadascontroller.isShowCity.value
                                            ? addadascontroller
                                                .listCities[index].name!
                                            : addadascontroller
                                                .listStates[index].name!),
                                    onTap: () {
                                      if (addadascontroller.isShowCity.value) {
                                        addadascontroller.selectedCity(
                                            addadascontroller
                                                .listCities[index]);
                                        GetStorage("agahi").write(
                                            "selectedCity",
                                            addadascontroller
                                                .listCities[index]);
                                        if (addadascontroller.selectedCity.value
                                            .districts!.isNotEmpty) {
                                          addadascontroller.listDistricts(
                                              addadascontroller.selectedCity
                                                  .value.districts);
                                          addadascontroller
                                              .isShowDistrict(true);
                                        } else {
                                          addadascontroller.selectedDistrict(
                                              DistrictModel());
                                          GetStorage('agahi').write(
                                              'selectedDistrict',
                                              addadascontroller
                                                  .selectedDistrict.value);
                                          addadascontroller
                                              .isLoadingCitiesAndStates(true);
                                          addadascontroller
                                              .isLoadingCitiesAndStates(false);
                                          // GetStorage('agahi').write('Districts', addadascontroller.listDistricts[index].toString());

                                          addadascontroller.saveData();
                                          Get.back();
                                        }
                                      } else {
                                        addadascontroller.getCities(
                                            addadascontroller
                                                .listStates[index].id!);
                                        addadascontroller.isShowCity(true);

                                        addadascontroller.saveData();
                                      }
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )),
        ),
      ),
    );
  }
}
