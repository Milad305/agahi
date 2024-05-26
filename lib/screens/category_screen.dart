import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/CategoryModel.dart';
import 'package:agahi_app/screens/category_ads.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
  final maincontroller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        maincontroller.getBackCategory();
        return Future(() => false);
      },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Cprimary, borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.list_alt_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'دسته بندی آگهی ها',
                      style: TextStyle(color: Colors.white),
                    )
                  ]),
            ),
            Expanded(
                child: Obx(() => maincontroller.isShowChild.value
                    ? ListView.builder(
                        itemCount: maincontroller.listCategoryChild.length,
                        padding: const EdgeInsets.only(bottom: 20, top: 5),
                        itemBuilder: (context, index) {
                          CategoryModel cat =
                              maincontroller.listCategoryChild[index];
                          return CategoryItem(
                            icon_right: SizedBox(
                                width: 25, height: 25, child: cat.getIcon()),
                            title_text: Text(
                              cat.name ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                            func: () {
                              if (cat.childsCount! > 0) {
                                maincontroller.getCategoryChild(cat.id!);
                              } else {
                                Get.to(
                                  CatAdsPage(
                                      catIndex: cat.id!, catTitle: cat.name!),
                                );
                                /*   maincontroller
                                    .getMyAdsFitlerByCategory(cat.id!);
                                maincontroller.bottomindex(0);*/
                              }
                              maincontroller.addCategoryRoute(
                                  cat: cat, isMain: false);
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: maincontroller.listCategory.length,
                        padding: const EdgeInsets.only(bottom: 20, top: 5),
                        itemBuilder: (context, index) {
                          CategoryModel cat =
                              maincontroller.listCategory[index];
                          return CategoryItem(
                            icon_right: SizedBox(
                                width: 25, height: 25, child: cat.getIcon()),
                            title_text: Text(
                              cat.name ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                            func: () {
                              maincontroller.isShowChild(true);
                              maincontroller.listCategoryRoute.clear();
                              maincontroller.addCategoryRoute(
                                  cat: cat, isMain: true);
                              maincontroller.getCategoryChild(cat.id!);
                            },
                          );
                        },
                      )))
          ],
        ),
      ),
    );
  }
}
