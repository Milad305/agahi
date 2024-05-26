import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/setting_controller.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DialogCityStateFirst extends StatelessWidget {
  const DialogCityStateFirst({super.key});

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    maincontroller.getStatesFirst();
    return Dialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Obx(() => ListView.builder(
                itemCount: maincontroller.isShowCityFirst.value
                    ? maincontroller.listCitiesFirst.length
                    : maincontroller.listStatesFirst.length,
                itemBuilder: (context, index) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: Text(maincontroller.isShowCityFirst.value
                          ? maincontroller.listCitiesFirst[index].name!
                          : maincontroller.listStatesFirst[index].name!),
                      onTap: () {
                        if (maincontroller.isShowCityFirst.value) {
                          CityModel cm = maincontroller.listCitiesFirst[index];
                          GetStorage('agahi')
                              .write('city', cm); //for main adding ads location
                          GetStorage('agahi').write('filter',
                              [cm]); //for filtering citis in adsscreen
                          maincontroller.getSettings();

                          maincontroller.getCategory();
                          maincontroller.getAds();
                          Get.offNamed('/main');
                        } else {
                          maincontroller.getCities(
                              maincontroller.listStatesFirst[index].id!);
                          maincontroller.isShowCityFirst(true);
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
