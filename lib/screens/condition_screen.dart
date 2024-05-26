import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import '../controller/main_controller.dart';

class ConditionScreen extends StatelessWidget {
  var main_controller = Get.find<MainController>();
  ConditionScreen({super.key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //    await main_controller.getStaticPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        body: SingleChildScrollView(
          child: Column(
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
                title: "شرایط استفاده از خدمات",
                title_icon: Icon(
                  Icons.privacy_tip_outlined,
                  color: Cwhite,
                  size: 20,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                padding: const EdgeInsets.all(20),
                width: Get.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 35,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "${main_controller.setting.value.rulls}",
                  style: const TextStyle(fontSize: 15),
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
