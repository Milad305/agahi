import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/screens/condition_screen.dart';
import 'package:agahi_app/screens/previcy_screen.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';
import '../widget/public_widget.dart';
import '../widget/widget.dart';

class SendCodeScreen extends StatelessWidget {
  const SendCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    maincontroller.textFieldPhoneNumber.clear();
    maincontroller.textFieldCheckCode.clear();
    maincontroller.isSendingCode(false);
    maincontroller.isVerifingCode(false);
    return SafeArea(
      child: CustomScaffold(
        body: Column(
          children: [
            CustomAppBar(
              bg_color: Cprimary,
              show_back: true,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      const Text("شماره موبایل خود را وارد کنید"),
                      const SizedBox(
                        height: 50,
                      ),
                      CodeTextField(
                        controller: maincontroller.textFieldPhoneNumber,
                        hintText: "0912 555 6589",
                        maxLength: 11,
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
                                style: TextStyle(color: Cprimary, fontSize: 13),
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
                                style: TextStyle(color: Cprimary, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          " را میپذیرم",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(() => ButtonAgahi(
                            padding: const EdgeInsets.only(top: 10.5),
                            height: 45,
                            width: Get.width,
                            bg_color: Cprimary,
                            child: maincontroller.isSendingCode.value
                                ? Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Cwhite,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "ارسال کد",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                            func: () {
                              maincontroller.time.value = 60;
                              maincontroller.resendVisible.value = false;
                              maincontroller.sendCode();
                            },
                          )),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
