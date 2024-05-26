import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/NotificationChatModel.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../widget/public_widget.dart';

class ChatNotificationScreen extends StatelessWidget {
  const ChatNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var chatcontroller = Get.find<ChatController>();
    return SafeArea(
      child: CustomScaffold(
        appBar: AppBar(
          leading: IconButton(
              highlightColor: Cwhite.withOpacity(.2),
              splashRadius: 20,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Cprimary,
          foregroundColor: Cwhite,
          centerTitle: true,
          title: const Text('اطلاع رسانی'),
        ),
        body: Column(
          children: [
           /* Obx(() {
              return Get.find<MainController>().isinternet.value == false
                  ? OflineMessage()
                  : Container();
            }),*/
            SizedBox(
              width: Get.width,
              height: Get.height - 60,
              child: Obx(() => ListView.builder(
                    itemCount: chatcontroller.listChatNotifications.length,
                    itemBuilder: (context, index) {
                      NotificationChatModel nm =
                          chatcontroller.listChatNotifications[index];
                      return ChatBox(
                        message: nm.body,
                        is_read: false,
                        is_self: false,
                        time: nm.createdAt.toString().get_created_at(),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
