import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class OurRulesScreen extends StatelessWidget {
  OurRulesScreen({super.key});
  final main_controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(
                bg_color: Cprimary,
                show_back: true,
                show_title: true,
                title: "قوانین",
                title_icon: Icon(
                  Icons.gavel_outlined,
                  color: Cwhite,
                  size: 18,
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                width: Get.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 35,
                      offset: Offset(0, 10),
                    ),
                  ],
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "${main_controller.setting.value.privacy}",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
