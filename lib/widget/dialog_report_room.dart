import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class DialogReportChat extends StatelessWidget {
  const DialogReportChat({super.key});

  @override
  Widget build(BuildContext context) {
    var chatcontroller = Get.find<ChatController>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              textAlign: TextAlign.right,
              controller: chatcontroller.reportText,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'متن خود را وارد نمایید',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Get.width,
              child: TextButton(
                  onPressed: () {
                    chatcontroller.sendReport();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Cprimary, foregroundColor: Cwhite),
                  child: const Text('ثبت گزارش')),
            )
          ],
        ),
      ),
    );
  }
}
