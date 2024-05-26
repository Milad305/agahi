import 'dart:io';

import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:agahi_app/widget/dialog_category.dart';
import 'package:agahi_app/widget/dialog_priority.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constant/colors.dart';
import '../widget/public_widget.dart';
import '../widget/widget.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({super.key});
  String allow_exts = "jpg,pdf,zip,jpeg,png";
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  var mainController = Get.find<MainController>();

  void select_attachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: allow_exts.split(","),
    );
    if (result != null) {
      mainController.attachments.clear();
      if (result.files.length > 2) {
        MySnackBar(
            "حداکثر دو فایل میتوانید انتخاب کنید",
            CerrorColor,
            Icon(
              Icons.error,
              color: Colors.red,
            ));
      } else {
        result.files.forEach((element) {
          var f = File(element.path!);
          if (f.lengthSync() <= 1000000)
            mainController.attachments.add(f);
          else
            MySnackBar(
                "حجم فایل ${element.name} باید کمتر از 1 مگابایت باشد",
                CerrorColor,
                Icon(
                  Icons.error,
                  color: Colors.red,
                ));
        });
      }
    }
  }

  void init() {
    mainController.selectedCategorySupport('');
    mainController.selectedPriority('');
    mainController.attachments.clear();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(
        child: CustomScaffold(
      body: Column(
        children: [
          CustomAppBar(
            bg_color: Cprimary,
            show_back: true,
            show_title: true,
            title: "پشتیبانی",
            title_icon: Icon(
              Icons.contact_phone,
              color: Cwhite,
              size: 20,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                const SizedBox(
                  height: 5,
                ),
                TextFeildSupport(
                  hintText: "عنوان",
                  controller: titleController,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                      boxShadow: [bs010],
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).cardColor),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const PriorityDialog();
                            },
                          );
                        },
                        child: Obx(
                          () {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text((mainController.selectedPriority.value ==
                                        '')
                                    ? 'اولویت'
                                    : mainController.selectedPriority.value),
                              ],
                            );
                          },
                        )),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        boxShadow: [bs010],
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Theme.of(context).cardColor),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const CategoryDialog();
                                },
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Obx(
                                  () {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text((mainController
                                                    .selectedCategorySupport
                                                    .value ==
                                                '')
                                            ? 'دسته بندی'
                                            : mainController
                                                .selectedCategorySupport.value),
                                      ],
                                    );
                                  },
                                )
                              ],
                            )))),
                const SizedBox(
                  height: 5,
                ),
                TextFeildSupport(
                  controller: descriptionController,
                  hintText: " متن خود را وارد نماید",
                  maxLines: 6,
                ),
                const SizedBox(
                  height: 5,
                ),
                Obx(() {
                  String title = "";
                  if (mainController.attachments.length > 0) {
                    mainController.attachments.forEach((element) {
                      title += "${element.uri.pathSegments.last} ";
                    });
                  } else {
                    title = "فایل ضمیمه";
                  }
                  return ContainerFile(
                    text: title,
                    on_click: () {
                      select_attachment();
                    },
                  );
                }),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "فرمت های قابل پشتیبانی: ${allow_exts}",
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(Get.width, 40),
                        backgroundColor: Cprimary,
                        foregroundColor: Cwhite),
                    onPressed: () {
                      var attachment_arr = <MultipartFile>[];

                      mainController.attachments.forEach((element) {
                        attachment_arr.add(MultipartFile(element,
                            filename: element.uri.pathSegments.last));
                      });

                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          mainController.selectedPriority != "" &&
                          mainController.selectedCategorySupport != "") {
                        mainController.submitSupportTicket(
                            title: titleController.text,
                            description: descriptionController.text,
                            periority: mainController.selectedPriority.value,
                            category:
                                mainController.selectedCategorySupport.value,
                            attachments: attachment_arr);
                      } else {
                        MySnackBar(
                            "پرکردن تمامی موارد الزامی است",
                            CerrorColor,
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            ));
                      }
                    },
                    child: Obx(
                      () {
                        if (mainController.submit_ticket_loading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        return Text('ارسال');
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
