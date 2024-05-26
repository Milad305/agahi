import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /* Obx(() {
            return Get.find<MainController>().isinternet.value == false
                ? OflineMessage()
                : Container();
          }),*/
        Container(
          width: Get.width / 1.5,
          height: Get.height / 4,
          decoration: BoxDecoration(
            color: CprimaryLight,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 70,
                color: Cprimary,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "برای شروع چت لطفا وارد حساب کاربری خود شوید",
                  style: TextStyle(fontSize: 13, color: Cprimary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        ButtonAgahi(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              color: Cprimary),
          func: () {
            Get.toNamed('/phonenumber');
          },
          child: Center(
            child: Text(
              "ورود",
              style: TextStyle(color: Cwhite),
            ),
          ),
        )
      ],
    )));
  }
}
