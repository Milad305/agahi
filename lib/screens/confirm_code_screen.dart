import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/screens/about_us_screen.dart';
import 'package:agahi_app/screens/condition_screen.dart';
import 'package:agahi_app/screens/previcy_screen.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../widget/public_widget.dart';
import '../widget/widget.dart';

class ConfirmCodeScreen extends StatelessWidget {
  var maincontroller = Get.find<MainController>();
  ConfirmCodeScreen({super.key}) {
    maincontroller.timerCancel();
    maincontroller.timer(60);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() {
      return Future.value(true);
    }

    return SafeArea(
      child: CustomScaffold(
        body: WillPopScope(
          onWillPop: () => onWillPop(),
          child: Column(
            children: [
              /*   Obx(() {
                return Get.find<MainController>().isinternet.value == false
                    ? OflineMessage()
                    : Container();
              }),*/
              CustomAppBar(
                bg_color: Cprimary,
                show_back: false,
                title_icon: Icon(
                  Icons.timelapse,
                  color: Cwhite,
                  size: 20,
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: Get.width * .8,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      boxShadow: [bs010],
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        const Text("کد تایید به شماره "),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("ارسال شده است"),
                            const SizedBox(
                              width: 4,
                            ),
                            Obx(() => maincontroller.refreshWidget.value
                                ? const SizedBox()
                                : Text(
                                    maincontroller.textFieldPhoneNumber.text))
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CodeTextField(
                          controller: maincontroller.textFieldCheckCode,
                          hintText: "1 2 3 4 5",
                          maxLength: 5,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              width: 1.5,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(PrevicyScreen());
                                },
                                child: Text(
                                  "حریم خصوصی",
                                  style:
                                      TextStyle(color: Cprimary, fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 1.5,
                            ),
                            // ignore: prefer_const_constructors
                            Align(
                              alignment: Alignment.topCenter,
                              child: const Text(
                                "و",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              width: 1.5,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(ConditionScreen());
                                },
                                child: Text(
                                  "شرایط استفاده از خدمات",
                                  style:
                                      TextStyle(color: Cprimary, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => Container(
                                  width: Get.width * .3,
                                  child: ButtonAgahi(
                                    padding: const EdgeInsets.only(top: 10.5),
                                    height: 45,
                                    width: Get.width,
                                    bg_color: Cprimary,
                                    child: maincontroller.isVerifingCode.value
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color: Cwhite,
                                            ),
                                          )
                                        : const Text(
                                            "  تایید کد",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                    func: () {
                                      maincontroller.checkCode();
                                    },
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                'اصلاح شماره',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Obx(() {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: maincontroller.resendVisible.value
                                ? Visibility(
                                    visible: maincontroller.resendVisible.value,
                                    child: TextButton(
                                      onPressed: maincontroller.resendOTP,
                                      child: const Text('ارسال مجدد کد',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 0, 140, 255))),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     const Text(
                                        'ثانیه تا ارسال مجدد  ',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text("${maincontroller.time.value}"),
                                    ],
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
