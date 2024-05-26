import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class PriorityDialog extends StatelessWidget {
  const PriorityDialog({super.key});

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
                      Text('کم'),
                    ],
                  ),
                  value: 'کم',
                  groupValue: maincontroller.selectedPriority.value,
                  onChanged: (value) {
                    maincontroller.selectedPriority(value);
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
                      Text('متوسط'),
                    ],
                  ),
                  value: 'متوسط',
                  groupValue: maincontroller.selectedPriority.value,
                  onChanged: (value) {
                    maincontroller.selectedPriority(value);
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
                      Text('زیاد'),
                    ],
                  ),
                  value: 'زیاد',
                  groupValue: maincontroller.selectedPriority.value,
                  onChanged: (value) {
                    maincontroller.selectedPriority(value);
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
