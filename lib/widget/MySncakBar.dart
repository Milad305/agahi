import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

SnackbarController MySnackBar(String mytext, Color snackcolor, Icon myicon) {
  bool isShort = false;
  if (mytext.length < 50) {
    isShort = true;
  }

  return Get.snackbar('title', 'message',
      messageText: Container(),
      titleText: Container(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      isDismissible: true,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      padding: const EdgeInsets.all(0),
      userInputForm: Form(
          child: Container(
        margin: const EdgeInsets.all(0),
        width: Get.width,
        height: isShort ? 30 : Get.height * .1,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          myicon,
          Expanded(
            child: Text(
              textScaleFactor: 1,
              maxLines: isShort ? 1 : 5,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
              mytext,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(width: 5, height: double.infinity, color: snackcolor),
        ]),
      )));
}
