import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../widget/public_widget.dart';
import '../widget/widget.dart';

class AccountScreen extends StatelessWidget {
  var maincontroller = Get.find<MainController>();
  AccountScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // maincontroller.isLoadingBookmark.value = true;
      // maincontroller.getSettings();
      //  maincontroller.isLoadingBookmark.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => maincontroller.isLoadingBookmark.value
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Material(
                        shape: const CircleBorder(),
                        color: Get.isDarkMode ? Colors.amber : CbgDark,
                        child: IconButton(
                            splashRadius: 23,
                            onPressed: () {
                              Get.changeThemeMode(Get.isDarkMode
                                  ? ThemeMode.light
                                  : ThemeMode.dark);
                              bool a = Get.isDarkMode;
                              GetStorage('agahi').write('isdarkmode', !a);
                            },
                            icon: Get.isDarkMode
                                ? const Icon(
                                    Icons.light_mode,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.dark_mode,
                                    color: Colors.white,
                                  )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5, right: 10, top: 2, bottom: 2),
                          height: 45,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BtnLogin(
                                is_login: maincontroller.isLoggedIn.value,
                                func: () {
                                  if (maincontroller.isLoggedIn.value) {
                                    GetStorage('agahi').remove('token');
                                    GetStorage('agahi').remove('phone');
                                    GetStorage('agahi').remove('id');
                                    GetStorage('agahi').remove('profile');
                                    maincontroller.phoneNumber('');
                                    maincontroller.isLoggedIn(false);
                                    Get.offAllNamed('/splash');
                                  } else {
                                    Get.toNamed('/phonenumber');
                                  }
                                },
                              ),
                              const Spacer(),
                              Obx(() => Text(maincontroller.phoneNumber == ''
                                  ? "شماره موبایل"
                                  : maincontroller.phoneNumber.value)),
                              const SizedBox(
                                width: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Icon(
                                  Icons.phone_enabled,
                                  size: 20,
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CategoryItem(
                  icon_right: Icon(
                    Icons.library_books,
                    color: Theme.of(context).highlightColor,
                  ),
                  title_text: const Text(" آگهی های من"),
                  func: () {
                    if (maincontroller.isLoggedIn.isFalse) {
                      Get.toNamed('/phonenumber');
                    } else {
                      Get.toNamed('/myads');
                    }
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.request_quote,
                      color: Theme.of(context).highlightColor),
                  title_text: const Text("پرداخت های من"),
                  func: () {
                    if (maincontroller.isLoggedIn.isFalse) {
                      Get.toNamed('/phonenumber');
                    } else {
                      Get.toNamed('/mypayments');
                    }
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.bookmark,
                      color: Theme.of(context).highlightColor),
                  title_text: Text("نشان ها و یادداشت ها"),
                  func: () {
                    if (maincontroller.isLoggedIn.isFalse) {
                      Get.toNamed('/phonenumber');
                    } else {
                      Get.toNamed('/bookmarkandnotes');
                    }
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.timelapse,
                      color: Theme.of(context).highlightColor),
                  title_text: Text("بازدید های اخیر"),
                  func: () {
                    if (maincontroller.isLoggedIn.isFalse) {
                      Get.toNamed('/phonenumber');
                    } else {
                      Get.toNamed('/recent');
                    }
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.settings,
                      color: Theme.of(context).highlightColor),
                  title_text: Text("تنظیمات"),
                  func: () async {
                    if (maincontroller.isLoggedIn.isFalse) {
                      Get.toNamed('/phonenumber');
                    } else {
                      await maincontroller.getSettings();
                      Get.toNamed('/setting');
                    }
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.contact_phone,
                      color: Theme.of(context).highlightColor),
                  title_text: Text("پشتیبانی"),
                  func: () {
                    if (maincontroller.isLoggedIn.isFalse) {
                      Get.toNamed('/phonenumber');
                    } else {
                      Get.toNamed('/support');
                    }
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.gavel_rounded,
                      color: Theme.of(context).highlightColor),
                  title_text: Text("قوانین"),
                  func: () {
                    Get.toNamed('/rules');
                  },
                ),
                CategoryItem(
                  icon_right: Icon(Icons.help_rounded,
                      color: Theme.of(context).highlightColor),
                  title_text: Text("سوالات متداول"),
                  func: () {
                    Get.toNamed('/questions');
                  },
                ),
                CategoryItem(
                  icon_right:
                      Icon(Icons.info, color: Theme.of(context).highlightColor),
                  title_text: Text("درباره ما"),
                  func: () {
                    Get.toNamed('/aboutus');
                  },
                ),
                Text("نسخه 1.0")
              ],
            ),
    ));
  }
}
