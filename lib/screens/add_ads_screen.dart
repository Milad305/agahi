import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/models/CategoryModel.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/models/DistrictModel.dart';
import 'package:agahi_app/screens/submit_ads_screen.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class AddAdsScreen extends StatelessWidget {
  var addadscontroller = Get.find<AddAdsController>();
  AddAdsScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return addadscontroller.isLoadingCategory.value
          ? Center(
              child:
                  CircularProgressIndicator(strokeWidth: 1.5, color: Cprimary),
            )
          : WillPopScope(
              onWillPop: () {
                if (addadscontroller.isCanBack.value) {
                  return Future(() => true);
                } else {
                  addadscontroller.getCategory();
                  return Future(() => false);
                }
              },
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Cprimary,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Row(
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.list_alt_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'ثبت آگهی',
                                style: TextStyle(color: Colors.white),
                              )
                            ]),
                      ),
                      Expanded(
                        child:
                            Obx(() => addadscontroller.isLoadingCategory.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1.5, color: Cprimary),
                                  )
                                : ListView.builder(
                                    itemCount:
                                        addadscontroller.listCategory.length,
                                    itemBuilder: (context, index) {
                                      CategoryModel cm =
                                          addadscontroller.listCategory[index];
                                      return ListTile(
                                        onTap: () {
                                          addadscontroller.isCanBack(false);
                                          if (cm.features!.length > 0) {
                                            addadscontroller.listCurrentFields
                                                .value = cm.features!;
                                          }
                                          if (cm.childsCount == 0) {
                                            addadscontroller
                                                .selectedCategoryId(cm.id);
                                            addadscontroller
                                                .selectedCity(CityModel());
                                            addadscontroller.selectedDistrict(
                                                DistrictModel());
                                            addadscontroller
                                                .selectedCategory(cm);
                                            Get.to(SubmitAdsScreen(
                                              cat: cm,
                                            ));
                                          } else {
                                            addadscontroller
                                                .getCategoryChild(cm.id!);
                                          }
                                        },
                                        title: Text(cm.name!),
                                        subtitle: cm.description == null
                                            ? null
                                            : Text(cm.description!),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Theme.of(context).cardColor,
                                        ),
                                      );
                                    },
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
