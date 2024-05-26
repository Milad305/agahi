import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: Column(
          children: [
         /*   Obx(() {
              return Get.find<MainController>().isinternet.value == false
                  ? OflineMessage()
                  : Container();
            }),*/
            CustomAppBar(
              bg_color: Cprimary,
              show_back: true,
              show_title: true,
              title: "وسایل نقلیه",
              title_icon: Icon(
                Icons.settings,
                color: Cwhite,
                size: 22,
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                CategoryItem(
                  title_text: Text(
                    "ماشین",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                CategoryItem(
                  title_text: Text(
                    "موتور",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                CategoryItem(
                  title_text: Text(
                    "وانت",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                CategoryItem(
                  title_text: Text(
                    "کامیون",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
