// ignore_for_file: iterable_contains_unrelated_type

import 'dart:async';
import 'dart:convert';
import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/models/ChatModel.dart';
import 'package:agahi_app/models/NotificationChatModel.dart';
import 'package:agahi_app/models/RoomModel.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatController2 extends GetxController {
  var listRooms = <RoomModel>[].obs;
  var listChats = <ChatModel>[].obs;
  var listChatNotifications = <NotificationChatModel>[].obs;
  var listChatSug = <String>[].obs;
  var isLoadingRooms = false.obs;
  var isLoadingChats = false.obs;
  var isLoadingChatSug = false.obs;
  var selectedChatId = 0.obs;
  var selectedAd = AdsModel().obs;
  var isBlocked = false.obs;
  var isConnected = false.obs;
  var retryCount = 0.obs;
  ScrollController? listScrollController = ScrollController();
  TextEditingController chatTextField = TextEditingController();
  TextEditingController reportText = TextEditingController();
  DateTime lastPing = DateTime.now();
  WebSocketChannel? channel;
  late StreamSubscription<dynamic> channelStream;
  // channel?.stream.asBroadcastStream();
  streamChannel() async {
    const maxRetryAttempts = 5;

    while (retryCount < maxRetryAttempts && isConnected.value == false) {
      try {
        //adb shell am start -a android.intent.action.VIEW \ -c android.intent.category.BROWSABLE \-d appchasbnak://deeplink.chasbnak.com/ads/1
        //xcrun simctl openurl booted appchasbnak://deeplink.chasbnak.com/ads/1
        print("connecting...");
        channel = IOWebSocketChannel.connect(
          Uri.parse(
              'ws://195.214.235.85:8012/ws/connection?token=${GetStorage('agahi').read('token')}'),
        );
        print("Connected");
        isConnected(true);
        channelStream = channel!.stream.listen(
          (event) {
            var jData = json.decode(event);
            if (jData["type"] == 'chat_message') {
              onChatMessageRecieve(jData["message"]);
            } else if (jData["type"] == 'seen') {
              onSeenMessageRecieve(jData["message"]);
            } else if (jData["type"] == 'block') {
              isBlocked(true);
            } else if (jData["type"] == 'ping') {
              lastPing = DateTime.now();
            }
          },
          onDone: () async {
            print('WebSocket closed');
            isConnected(false);
            // Reconnect
            await Future.delayed(Duration(seconds: 5));
            streamChannel();
          },
          onError: (error) async {
            print('WebSocket error: $error');
            isConnected(false);
            // Reconnect
            await Future.delayed(Duration(seconds: 5));
            streamChannel();
          },
        );
      } catch (e) {
        print("Error connecting: $e");
        // Retry connection after delay
        await Future.delayed(Duration(seconds: 5));
        streamChannel();
      }
      retryCount++;
    }
  }

  deleteMessage(id) {
    ApiProvider().deleteMessage(id).then((res) {
      if (res.isOk) {
        listChats.value.removeWhere((element) => element.id == id);
        listChats.refresh();
        update();
        Get.back();
      } else {
        Get.snackbar("خطا", "امکان حذف پیام دیده شده نمی باشد.");
      }
    });
  }

/*
  streamChannel() async {
    if (isConnected.isFalse) {
      try {
        print("conecting...");

        channel ??= WebSocketChannel.connect(
          Uri.parse(
              'ws://195.214.235.85:8012/ws/connection?token=${GetStorage('agahi').read('token')}'),
        );
        print("Channel status: ${channel!.sink.done}");
        print("Channel stream: ${channel!.stream}");
        // Listen to WebSocket stream
        channelStream?.listen(
          (event) {
            var jData = json.decode(event);
            if (jData["type"] == 'chat_message') {
              onChatMessageRecieve(jData["message"]);
            } else if (jData["type"] == 'seen') {
              onSeenMessageRecieve(jData["message"]);
            } else if (jData["type"] == 'block') {
              isBlocked(true);
            } else if (jData["type"] == 'ping') {
              lastPing = DateTime.now();
            }
          },
        );
      } on Exception catch (e) {
        print(e);
        return await streamChannel();
      }
      isConnected(true);
    }

    channel!.sink.done.then((_) async {
      print('WebSocket closed');
      isConnected(false);
      await streamChannel();
      // You may want to handle reconnection or cleanup here.
    });
  }
*/
  void getNotifications() {
    listChatNotifications.clear();
    ApiProvider().getNotifications().then((res) {
      if (res.isOk) {
        List tmp = res.body;
        for (var element in tmp) {
          listChatNotifications.add(NotificationChatModel.fromJson(element));
        }
        print(listChatNotifications.length);
      }
    });
  }

  void blockChat() {
    ApiProvider().blockChat(chatRoomId: selectedChatId.value).then((res) {
      if (res.isOk) {
        MySnackBar(
            res.body['data'],
            CsuccessColor,
            Icon(
              Icons.fact_check_rounded,
              color: CsuccessColor,
            ));
      } else {
        MySnackBar(
            res.body['message'],
            CwarningColor,
            Icon(
              Icons.error_outline,
              color: CwarningColor,
            ));
      }
    });
  }

  void sendReport() {
    if (reportText.text.isNotEmpty) {
      ApiProvider()
          .reportChat(
              chatRoomId: selectedChatId.value, message: reportText.text)
          .then((res) {
        if (res.isOk) {
          Get.back();
          MySnackBar(
              res.body['data'],
              CsuccessColor,
              Icon(
                Icons.fact_check_rounded,
                color: CsuccessColor,
              ));
          reportText.clear();
        } else {
          MySnackBar(
              res.body['data'],
              CwarningColor,
              Icon(
                Icons.error_outline,
                color: CwarningColor,
              ));
        }
      });
    }
  }

  onChatMessageRecieve(String message) {
    var mes = json.decode(message);
    ChatModel item = ChatModel(
      id: mes["id"],
      message: mes["message"],
      createdAt: mes["created_at"],
      isSeen: mes["is_seen"],
      sender: mes["sender"],
    );
    var x = listChats.value.where((element) => element.id == item.id).toList();
    if (x.isEmpty) {
      listChats.add(ChatModel(
        id: mes["id"],
        message: mes["message"],
        createdAt: mes["created_at"],
        isSeen: mes["is_seen"],
        sender: mes["sender"],
      ));
      if (mes["room_id"] == selectedChatId.value) {
        Timer(const Duration(milliseconds: 100), () {
          listScrollController!.animateTo(
              listScrollController!.position.maxScrollExtent + 500,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        });
      } else {
        int x = int.parse(GetStorage('agahi').read('id').toString());

        x != mes["sender"]
            ? showNotification(mes["ads_title"], mes["message"])
            : null;
      }
    }
  }

  onSeenMessageRecieve(String message) {
    listChats.where((p0) => p0.id == int.parse(message)).forEach((element) {
      element.isSeen = true;
    });
    listChats.refresh();
  }

  sendSocketMessage(Map<String, dynamic> data) {
    channel!.sink.add(json.encode(data));
  }

  sendSeenMessage(int messageid) {
    Map mp = {
      'message_id': messageid,
    };
    channel!.sink.add(json.encode({
      'type': 'seen',
      'message': mp,
    }));
  }

  sendMessage({required String txt, String? roomId}) async {
    Map mp = {'ads_id': selectedAd.value.id, 'message': txt, 'room_id': roomId};

    /*channel!.sink.add(json.encode({
      'type': 'chat_message',
      'message': mp,
    }));
    chatTextField.text = '';*/
    try {
      chatTextField.text = '';
      if (selectedChatId.value == 0) {
        await getRooms();
      }

      channel!.sink.add(json.encode({
        'type': 'chat_message',
        'message': mp,
      }));
      /* channelStream?.listen(
        (event) {
          var j_data = json.decode(event);
          if (j_data["type"] == 'chat_message') {
            onChatMessageRecieve(j_data["message"]);
          } else if (j_data["type"] == 'seen') {
            onSeenMessageRecieve(j_data["message"]);
          } else if (j_data["type"] == 'block') {
            isBlocked(true);
          } else if (j_data["type"] == 'ping') {
            lastPing = DateTime.now();
          }
        },
      );*/
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    channel!.sink.close();
    super.dispose();
  }

  getRooms() async {
    getNotifications();
    listRooms.clear();
    isLoadingRooms(true);
    if (!isConnected.value && Get.find<MainController>().isinternet.value) {
      await streamChannel();
      // getRooms();
      getOfflineRoom();
    } else {
      try {
        ApiProvider().getRooms().then((res) async {
          if (res.isOk) {
            List tmp = res.body['data'];
            await GetStorage('agahi').write('chatrooms', jsonEncode(tmp));
            for (var element in tmp) {
              listRooms.add(RoomModel.fromJson(element));
              if (listRooms.last.ads!.id == selectedAd.value.id) {
                selectedAd.value.chatId = listRooms.last.id;
                selectedChatId.value = listRooms.last.id!;
              }
            }
            isLoadingRooms(false);
          } else {
            var x = GetStorage('agahi').read('chatrooms');
            if (x != null) {
              List tmp = jsonDecode(GetStorage('agahi').read('chatrooms'));
              for (var element in tmp) {
                listRooms.add(RoomModel.fromJson(element));
                if (listRooms.last.ads!.id == selectedAd.value.id) {
                  selectedAd.value.chatId = listRooms.last.id;
                  selectedChatId.value = listRooms.last.id!;
                }
              }
              isLoadingRooms(false);
            }
            /*     MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            )); */
          }
        });
      } catch (e) {
        if (GetStorage('agahi').hasData('chatrooms')) {
          List tmp = jsonDecode(GetStorage('agahi').read('chatrooms'));
          for (var element in tmp) {
            listRooms.add(RoomModel.fromJson(element));
            if (listRooms.last.ads!.id == selectedAd.value.id) {
              selectedAd.value.chatId = listRooms.last.id;
              selectedChatId.value = listRooms.last.id!;
            }
          }
          isLoadingRooms(false);
        }
      }
    }
  }

  getOfflineRoom() {
    try {
      ApiProvider().getRooms().then((res) async {
        if (res.isOk) {
          List tmp = res.body['data'];
          await GetStorage('agahi').write('chatrooms', jsonEncode(tmp));
          for (var element in tmp) {
            listRooms.add(RoomModel.fromJson(element));
            if (listRooms.last.ads!.id == selectedAd.value.id) {
              selectedAd.value.chatId = listRooms.last.id;
              selectedChatId.value = listRooms.last.id!;
            }
          }
          isLoadingRooms(false);
        } else {
          var x = GetStorage('agahi').read('chatrooms');
          if (x != null) {
            List tmp = jsonDecode(GetStorage('agahi').read('chatrooms'));
            for (var element in tmp) {
              listRooms.add(RoomModel.fromJson(element));
              if (listRooms.last.ads!.id == selectedAd.value.id) {
                selectedAd.value.chatId = listRooms.last.id;
                selectedChatId.value = listRooms.last.id!;
              }
            }
            isLoadingRooms(false);
          }
          /*     MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            )); */
        }
      });
    } catch (e) {
      if (GetStorage('agahi').hasData('chatrooms')) {
        List tmp = jsonDecode(GetStorage('agahi').read('chatrooms'));
        for (var element in tmp) {
          listRooms.add(RoomModel.fromJson(element));
          if (listRooms.last.ads!.id == selectedAd.value.id) {
            selectedAd.value.chatId = listRooms.last.id;
            selectedChatId.value = listRooms.last.id!;
          }
        }
        isLoadingRooms(false);
      }
    }
  }

  getChats() {
    getChatSug();
    listChats.clear();
    isLoadingChats(true);
    try {
      ApiProvider().getChats(selectedAd.value.chatId ?? 0).then((res) async {
        if (res.isOk) {
          List tmp = res.body['data'];
          await GetStorage('agahi').write('chats', jsonEncode(tmp));
          for (var element in tmp) {
            listChats.add(ChatModel.fromJson(element));
          }
          isLoadingChats(false);

          if (tmp.length > 0) {
            Timer(const Duration(milliseconds: 200), () {
              listScrollController!.animateTo(
                  listScrollController!.position.maxScrollExtent + 500,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn);
            });
          }
        } else {
          if (GetStorage('agahi').hasData('chats')) {
            List tmp = jsonDecode(GetStorage('agahi').read('chats'));
            for (var element in tmp) {
              listChats.add(ChatModel.fromJson(element));
            }
            isLoadingChats(false);
          }
        }
      });
    } catch (e) {
      if (GetStorage('agahi').hasData('chats')) {
        List tmp = jsonDecode(GetStorage('agahi').read('chats'));
        for (var element in tmp) {
          listChats.add(ChatModel.fromJson(element));
        }
        isLoadingChats(false);
      }
    }
  }

  getChatSug() {
    listChatSug.clear();
    isLoadingChatSug(true);
    try {
      ApiProvider()
          .getChatSuggestion(selectedAd.value.category!.id!)
          .then((res) async {
        if (res.isOk) {
          List tmp = res.body['data'];
          await GetStorage('agahi').write('chatsug', jsonEncode(tmp));
          if (tmp.length > 0) {
            for (var element in tmp) {
              listChatSug.add(element['message_text']);
            }
            Timer(const Duration(milliseconds: 200), () {
              listScrollController!.animateTo(
                  listScrollController!.position.maxScrollExtent + 500,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn);
            });
          }

          isLoadingChatSug(false);
        } else {
          if (GetStorage('agahi').hasData('chatsug')) {
            List tmp = jsonDecode(GetStorage('agahi').read('chatsug'));
            if (tmp.length > 0) {
              for (var element in tmp) {
                listChatSug.add(element['message_text']);
              }
              isLoadingChatSug(false);
            }
          }
        }
      });
    } catch (e) {
      if (GetStorage('agahi').hasData('chatsug')) {
        List tmp = jsonDecode(GetStorage('agahi').read('chatsug'));
        if (tmp.length > 0) {
          for (var element in tmp) {
            listChatSug.add(element['message_text']);
          }
          isLoadingChatSug(false);
        }
      }
    }
  }

  showNotification(String? titleAd, String? message) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: titleAd,
            body: message,
            actionType: ActionType.DisabledAction));
  }
}

class ChatController extends GetxController {
  
}
