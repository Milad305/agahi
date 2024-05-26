import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class CategoryDialog extends StatelessWidget {
  const CategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  activeColor: Cprimary,
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text('نظر'),
                    ],
                  ),
                  value: 'نظر',
                  groupValue: maincontroller.selectedCategorySupport.value,
                  onChanged: (value) {
                    maincontroller.selectedCategorySupport(value);
                    Get.back();
                  },
                ),
                RadioListTile(
                  activeColor: Cprimary,
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text('انتقاد'),
                    ],
                  ),
                  value: 'انتقاد',
                  groupValue: maincontroller.selectedCategorySupport.value,
                  onChanged: (value) {
                    maincontroller.selectedCategorySupport(value);
                    Get.back();
                  },
                ),
                RadioListTile(
                  activeColor: Cprimary,
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text('پیشنهاد'),
                    ],
                  ),
                  value: 'پیشنهاد',
                  groupValue: maincontroller.selectedCategorySupport.value,
                  onChanged: (value) {
                    maincontroller.selectedCategorySupport(value);
                    Get.back();
                  },
                ),
                RadioListTile(
                  activeColor: Cprimary,
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text('گزارش خطای برنامه'),
                    ],
                  ),
                  value: 'گزارش خطای برنامه',
                  groupValue: maincontroller.selectedCategorySupport.value,
                  onChanged: (value) {
                    maincontroller.selectedCategorySupport(value);
                    Get.back();
                  },
                ),
                RadioListTile(
                  activeColor: Cprimary,
                  title: Row(
                    textDirection: TextDirection.rtl,
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text('سایر'),
                    ],
                  ),
                  value: 'سایر',
                  groupValue: maincontroller.selectedCategorySupport.value,
                  onChanged: (value) {
                    maincontroller.selectedCategorySupport(value);
                    Get.back();
                  },
                ),
                const SizedBox(
                  height: 10,
                )
              ])),
    );
  }
}
