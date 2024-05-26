import 'package:agahi_app/controller/setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class DialogCityStateSetting extends StatelessWidget {
  const DialogCityStateSetting({super.key});

  @override
  Widget build(BuildContext context) {
    var settingcontroller = Get.find<SettingController>();
    return Dialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(() => ListView.builder(
                itemCount: settingcontroller.isShowCity.value
                    ? settingcontroller.listCities.length
                    : settingcontroller.listStates.length,
                itemBuilder: (context, index) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: Text(settingcontroller.isShowCity.value
                          ? settingcontroller.listCities[index].name!
                          : settingcontroller.listStates[index].name!),
                      onTap: () {
                        if (settingcontroller.isShowCity.value) {
                          settingcontroller.selectedCity =
                              settingcontroller.listCities[index];
                          settingcontroller.updateProfile();
                          settingcontroller.isLoadingCitiesAndStates(true);
                          settingcontroller.isLoadingCitiesAndStates(false);
                          Get.back();
                        } else {
                          settingcontroller.getCities(
                              settingcontroller.listStates[index].id!);
                          settingcontroller.isShowCity(true);
                        }
                      },
                    ),
                  );
                },
              )),
        ),
      ),
    );
  }
}
