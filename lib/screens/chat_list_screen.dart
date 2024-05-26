import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/RoomModel.dart';
import 'package:agahi_app/screens/chat_screen.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var chatcontroller = Get.find<ChatController>();
    return SafeArea(
      child: Column(
        children: [
          Obx(() => ChatListItem(
                func: () {
                  Get.toNamed('/notification');
                },
                image: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Theme.of(context).highlightColor,
                  ),
                ),
                unreadCount: 0,
                text_title: "اطلاع رسانی",
                text_item: chatcontroller.listChatNotifications.isEmpty
                    ? ''
                    : chatcontroller
                        .listChatNotifications[
                            chatcontroller.listChatNotifications.length - 1]
                        .body,
                is_pin: true,
                time: chatcontroller.listChatNotifications.isEmpty
                    ? ''
                    : chatcontroller
                        .listChatNotifications[
                            chatcontroller.listChatNotifications.length - 1]
                        .createdAt
                        .toString()
                        .get_created_at(),
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: Obx(() => chatcontroller.isLoadingRooms.value
                  ? Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5, color: Cprimary),
                    )
                  : chatcontroller.listRooms.isEmpty
                      ? const Center(
                          child: Text('اطلاعاتی برای نمایش وجود ندارد'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: chatcontroller.listRooms.length,
                          itemBuilder: (context, index) {
                            RoomModel rm = chatcontroller.listRooms[index];
                            return ChatListItem(
                              image: rm.ads?.getPreviewImage() == null
                                  ? Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    )
                                  : Image.network(
                                      fit: BoxFit.cover,
                                      rm.ads!.getPreviewImage()!),
                              unreadCount: rm.UnreadCount!,
                              text_title: rm.ads?.title ?? 'نام وارد نشده',
                              text_item: rm.lastMessage ?? '',
                              time: rm.createdAt.toString().get_created_at(),
                              func: () {
                                chatcontroller.isBlocked(rm.isBlocked);
                                chatcontroller.selectedChatId(rm.id);
                                chatcontroller.selectedAd(rm.ads);
                                chatcontroller.chatTextField.text == '';
                                Get.to(ChatScreen(
                                  ads: rm.ads,
                                ));
                              },
                            );
                          },
                        )))
        ],
      ),
    );
  }
}
