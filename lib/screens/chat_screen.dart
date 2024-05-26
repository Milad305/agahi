import 'dart:async';
import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/models/ChatModel.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:agahi_app/widget/dialog_report_room.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import '../widget/MySncakBar.dart';

class ChatScreen extends StatelessWidget {
  AdsModel? ads;
  ChatScreen({super.key, this.ads});

  @override
  Widget build(BuildContext context) {
    var chatcontroller = Get.find<ChatController>();

    Timer(Duration.zero, () {
      chatcontroller.getChats();
      unFocus();
    });
    return WillPopScope(
      onWillPop: () async {
        await chatcontroller.getRooms();
        chatcontroller.selectedChatId(0);
        return true;
      },
      child: SafeArea(
        child: CustomScaffold(
          appBar: AppBar(
              leading: IconButton(
                  highlightColor: Cwhite.withOpacity(.2),
                  splashRadius: 20,
                  onPressed: () {
                    Get.back();
                    //chatcontroller.selectedChatId(0);
                    chatcontroller.getRooms();
                  },
                  icon: const Icon(Icons.arrow_back)),
              backgroundColor: Cprimary,
              foregroundColor: Cwhite,
              centerTitle: true,
              title: const Text(
                'چت',
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                PopupMenuButton(
                  splashRadius: 20,
                  tooltip: 'گزینه ها',
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColorLight,
                  icon: Icon(
                    Icons.more_vert,
                    color: Cwhite,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          padding: EdgeInsets.zero,
                          onTap: null,
                          child: Center(
                              child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                foregroundColor: Theme.of(context).cardColor,
                                fixedSize: Size(Get.width, 50)),
                            onPressed: () {
                              chatcontroller.blockChat();
                              Get.back();
                            },
                            child: const Text(
                              'مسدود کردن',
                              style: TextStyle(fontSize: 15),
                            ),
                          ))),
                      PopupMenuItem(
                          padding: EdgeInsets.zero,
                          onTap: null,
                          child: Center(
                              child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                foregroundColor: Theme.of(context).cardColor,
                                fixedSize: Size(Get.width, 50)),
                            onPressed: () {
                              if (chatcontroller.listChats.isNotEmpty) {
                                Get.back();
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const DialogReportChat(),
                                );
                              }
                            },
                            child: const Text('گزارش تخلف',
                                style: TextStyle(fontSize: 15)),
                          ))),
                    ];
                  },
                ),
              ]),
          body: Column(
            children: [
            
            /*    Obx(() {
                return Get.find<MainController>().isinternet.value == false
                    ? OflineMessage()
                    : Container();
              }),*/
              const SizedBox(
                height: 10,
              ),
              ChatHeaderCard(
                onTap: () =>
                    ads != null ? Get.to(ShowAdsScreen(ads: ads!)) : {},
                text: chatcontroller.selectedAd.value.title ?? '',
                image: chatcontroller.selectedAd.value.getPreviewImage(),
              ),
              Expanded(
                child: Obx(() => chatcontroller.isLoadingChats.value
                    ? Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 1.5, color: Cprimary),
                      )
                    : chatcontroller.listChats.isEmpty
                        ? const Center(
                            child: Text('اطلاعاتی برای نمایش وجود ندارد'),
                          )
                        : Obx(() {
                            return chatcontroller.listChats.length > 0
                                ? ListView.builder(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    controller:
                                        chatcontroller.listScrollController,
                                    itemCount: chatcontroller.listChats.length,
                                    itemBuilder: (context, index) {
                                      ChatModel ct =
                                          chatcontroller.listChats[index];
                                      if (ct.isSeen == false) {
                                        chatcontroller.sendSeenMessage(ct.id!);
                                      }
                                      return ChatBox(
                                        id: ct.id,
                                        message: ct.message,
                                        is_read: ct.isSelf() ? ct.isSeen : null,
                                        is_self: ct.isSelf(),
                                        time: ct.createdAt
                                            .toString()
                                            .get_created_at(),
                                      );
                                    },
                                  )
                                : Container();
                          })),
              ),
              Obx(
                () => chatcontroller.isLoadingChatSug.value
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                            strokeWidth: 1.5, color: Cprimary),
                      )
                    : chatcontroller.listChatSug.isEmpty
                        ? const SizedBox()
                        : Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            margin: const EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            decoration: BoxDecoration(
                                boxShadow: [bs010],
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(5)),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Opacity(
                                opacity: .7,
                                child: ListView.builder(
                                  itemCount: chatcontroller.listChatSug.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(left: 5),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        chatcontroller.sendMessage(
                                            txt: chatcontroller
                                                .listChatSug[index],
                                            roomId: chatcontroller
                                                .selectedChatId.value
                                                .toString());
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .cardColor
                                                    .withOpacity(.5))),
                                        margin: const EdgeInsets.only(right: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(chatcontroller
                                                .listChatSug[index])),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
              ),
              Obx(
                () => chatcontroller.isBlocked.value
                    ? Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'این گفتگو مسدود شده است',
                          style: TextStyle(color: Cwhite),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ChatTextField(
                          on_send_click: () {
                            print("sending");
                            if (chatcontroller.chatTextField.text.isEmpty) {
                              MySnackBar(
                                  'لطفا متن خود را وارد نمایید',
                                  CwarningColor,
                                  Icon(
                                    Icons.warning_rounded,
                                    color: CwarningColor,
                                  ));
                            } else {
                              chatcontroller.sendMessage(
                                  txt: chatcontroller.chatTextField.text,
                                  roomId: chatcontroller.selectedChatId.value
                                      .toString());
                            }
                          },
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
