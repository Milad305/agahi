import 'dart:async';

import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widget/dialog_city_state_first.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    maincontroller.runsplash();
    Timer(const Duration(seconds: 2), () {
      if (GetStorage('agahi').hasData('city')) {
        maincontroller.getSettings();
        maincontroller.getCategory();
        maincontroller.getAds();
        Get.offNamed('/main');
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const DialogCityStateFirst();
          },
        );
      }

      maincontroller.runsplash();
    });

    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: SafeArea(
        child: CustomScaffold(
          backgroundColor: Cprimary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          color: Colors.white,
                          width: 200,
                          height: 200,
                          child: Image.asset('assets/images/ic_logo.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(),
                Column(
                  children: [
                    CircularProgressIndicator(
                      color: Cwhite,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "نسخه 1.0",
                      style: TextStyle(color: Cwhite),
                      textDirection: TextDirection.rtl,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
