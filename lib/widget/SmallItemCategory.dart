import 'package:agahi_app/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../models/CategoryModel.dart';

class ItemSmallCategory extends StatelessWidget {
  final CategoryModel categorymodel;
  int index = 0;
  final controller;
  ItemSmallCategory({
    required this.categorymodel,
    required this.index,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 25,
        padding: const EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: controller.selectedcat.value == index
                ? Cprimary
                : Colors.transparent),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).highlightColor),
            onPressed: () {
              controller.selectedcat(index);
              Get.find<MainController>()
                  .getMyAdsFitlerByCategorymain(categorymodel.id!);
              Get.find<MainController>().currentCat.value = categorymodel.id!;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                categorymodel.getIcon() == null
                    ? SizedBox(
                        height: 3,
                      )
                    : SizedBox(
                        width: 20,
                        height: 20,
                        child: categorymodel.getIcon(),
                      ),
                Expanded(
                  child: Center(
                    child: Text(
                      categorymodel.name ?? '',
                      style: TextStyle(
                          fontSize: 13,
                          color: controller.selectedcat.value == index
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                )
              ],
            )),
      );
    });
  }
}
