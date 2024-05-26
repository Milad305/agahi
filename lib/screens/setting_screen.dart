import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/setting_controller.dart';
import 'package:agahi_app/widget/dialog_city_state_setting.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:agahi_app/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  var mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    var settingcontroller = Get.find<SettingController>();
    return WillPopScope(
      onWillPop: () async {
        settingcontroller.hasUpdate.value
            ? {
                settingcontroller.updateProfile(),
                settingcontroller.hasUpdate.value = false
              }
            : null;
        Get.back();
        return true;
      },
      child: SafeArea(
        child: CustomScaffold(
          body: Column(
            children: [
              CustomAppBar(
                bg_color: Cprimary,
                show_back: true,
                show_title: true,
                title: "تنظیمات",
                title_icon: Icon(
                  Icons.settings,
                  color: Cwhite,
                  size: 22,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                width: Get.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [bs010],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /*  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: TextDirection.rtl,
                        children: [
                          const Text("شهر"),
                          TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Cprimary,
                                  foregroundColor: Cwhite),
                              onPressed: () {
                                settingcontroller.isShowCity(false);
                                settingcontroller.getStates();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const DialogCityStateSetting();
                                  },
                                );
                              },
                              child: Obx(
                                //  settingcontroller.selectedCity
                                () => settingcontroller
                                        .isLoadingCitiesAndStates.isFalse
                                    ? Text(settingcontroller.selectedCity ==
                                            null
                                        ? 'انتخاب'
                                        : settingcontroller.selectedCity!.name!)
                                    : const SizedBox(),
                              ))
                        ],
                      ),
                    ),
                   */
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: Get.width,
                      color: Colors.grey.shade300,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "تنظیمات چت",
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        const Text(
                          "نمایش اطلاع رسانی ها",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.right,
                        ),
                        Obx(() => CupertinoSwitch(
                              value: maincontroller.showMessages.value,
                              onChanged: (value) {
                                maincontroller.showMessages(
                                    !maincontroller.showMessages.value);
                                settingcontroller.updateProfile();
                              },
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        const Text(
                          "نمایش مکالمه های مسدود ",
                          style: TextStyle(fontSize: 13),
                        ),
                        Obx(() => CupertinoSwitch(
                              value: maincontroller.showBlocedMessages.value,
                              onChanged: (value) {
                                maincontroller.showBlocedMessages(
                                    !maincontroller.showBlocedMessages.value);
                                settingcontroller.updateProfile();
                              },
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const Text(
                      "اطلاعات فردی",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SubmitTextFieldWidget(
                          onChange: ((p0) {
                            settingcontroller.hasUpdate(true);
                          }),
                          height: 40,
                          controller: settingcontroller.nameController,
                          hint: 'نام خود را وارد کنید',
                          isRequired: false,
                          title: 'نام'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SubmitTextFieldWidget(
                          onChange: ((p0) {
                            settingcontroller.hasUpdate(true);
                          }),
                          height: 40,
                          controller: settingcontroller.lastnameController,
                          hint: 'نام خانوادگی خود را وارد کنید',
                          isRequired: false,
                          title: 'نام خانوادگی'),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonAgahi(
                    func: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogueCancelMassage(
                              text: 'از حذف یادداشت ها مطمئن هستید؟',
                              deletefunc: () {
                                Get.back();
                                settingcontroller.getDeleteAction(0);
                              },
                            );
                          });
                    },
                    padding: const EdgeInsets.all(10),
                    width: Get.width / 2.5,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: [bs010],
                        color: Theme.of(context).primaryColorLight,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Wrap(
                      children: const [
                        Text(
                          "حذف یادداشت ها",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ButtonAgahi(
                    func: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogueCancelMassage(
                              text: 'از حذف نشان ها مطمئن هستید؟',
                              deletefunc: () {
                                Get.back();
                                settingcontroller.getDeleteAction(1);
                              },
                            );
                          });
                    },
                    padding: const EdgeInsets.all(10),
                    width: Get.width / 2.5,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: [bs010],
                        color: Theme.of(context).primaryColorLight,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "حذف نشان ها",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonAgahi(
                    padding: const EdgeInsets.all(10),
                    width: Get.width / 2.5,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: [bs010],
                        color: Theme.of(context).primaryColorLight,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "حذف تاریخچه جستجو",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ButtonAgahi(
                    func: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogueCancelMassage(
                              text: 'از حذف بازدیدهای اخیر مطمئن هستید؟',
                              deletefunc: () {
                                settingcontroller.getDeleteAction(2);
                                Get.back();
                              },
                            );
                          });
                    },
                    padding: const EdgeInsets.all(10),
                    width: Get.width / 2.5,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: [bs010],
                        color: Theme.of(context).primaryColorLight,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "حذف بازدید های اخیر",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
