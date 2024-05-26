// ignore_for_file: must_be_immutable
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/constant/numtopersian.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/manage_ads_controller.dart';
import 'package:agahi_app/models/PlanModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

// CustomAppBar
class CustomAppBar extends StatelessWidget {
  bool? show_title = false;
  bool? show_back = false;
  String? title;
  Icon? title_icon;
  Color? bg_color;
  BorderRadius? borderRadius;
  EdgeInsets? padding;
  double? fonte_size;
  double? width;
  double? height;
  Widget? children;
  CustomAppBar(
      {this.show_title,
      this.bg_color,
      this.borderRadius,
      this.fonte_size,
      this.height,
      this.padding,
      this.show_back,
      this.width,
      this.title,
      this.title_icon,
      this.children,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (show_title != null)
              ? Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: bg_color ?? Cprimary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "$title",
                        style: TextStyle(color: Cwhite, fontSize: 13),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      (title_icon != null) ? title_icon! : Container(),
                    ],
                  ),
                )
              : Container(),
          (show_back == true)
              ? TextButton(
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Cprimary,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back))
              : const SizedBox(),
        ],
      ),
    );
  }
}

// CategoryItem
class CategoryItem extends StatelessWidget {
  Widget? icon_right;
  Text? title_text;
  double? width;
  double? icon_size;
  double? height;
  EdgeInsets? padding;
  EdgeInsets? margin;
  Function()? func;

  CategoryItem(
      {this.icon_right,
      this.icon_size,
      this.padding,
      this.margin,
      this.width,
      this.height,
      this.title_text,
      this.func,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
          margin: margin ??
              const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
          padding: padding,
          width: width ?? Get.width,
          height: height ?? 45,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [bs010],
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Theme.of(context).cardColor,
                  size: icon_size ?? 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    icon_right ?? Container(),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      child: title_text ?? Container(),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

//ButtonAgahi

class ButtonAgahi extends StatelessWidget {
  Decoration? decoration;
  Color? bg_color;
  double? width;
  double? height;
  EdgeInsets? padding;
  Widget? child;
  Function()? func;

  ButtonAgahi(
      {this.decoration,
      this.bg_color,
      this.height,
      this.padding,
      this.width,
      this.child,
      this.func,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: decoration ??
            BoxDecoration(
              color: bg_color ?? Cprimary,
              borderRadius: BorderRadius.circular(22),
            ),
        padding: padding ?? const EdgeInsets.all(5),
        width: width ?? Get.width / 1.5,
        height: height ?? 35,
        child: child,
      ),
      onTap: func,
    );
  }
}

// Chat Appbar

class FilledAppbar extends StatelessWidget {
  const FilledAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        height: 45,
        decoration: BoxDecoration(
          color: Cprimary,
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_back,
                color: Cwhite,
              ),
              Text(
                "احمدی",
                style: TextStyle(color: Cwhite),
              ),
              Icon(Icons.more_vert_outlined, color: Cwhite)
            ],
          ),
        ));
  }
}

// TextViewCardChat

class TextViewCardChat extends StatelessWidget {
  const TextViewCardChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 30,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: CRed,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "این گفتگو مسدود شده است",
          style: TextStyle(color: Cwhite),
        ),
      ),
    );
  }
}

// ChatBox

class ChatBox extends StatelessWidget {
  int? id;
  bool? is_read;
  bool? is_self;
  String? message;
  String? time;

  ChatBox(
      {this.id,
      this.is_self,
      this.is_read,
      this.message,
      this.time,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment:
            (is_self == true) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          (is_self == true)
              ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        //show a modelsheet for delete message
                        showBottomSheetExample(context, () {
                          Get.find<ChatController>().deleteMessage(id);
                        }, id);
                      },
                      icon: Icon(Icons.more_vert)))
              : Container(),
          Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 10),
            width: Get.width / 2,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
                color: (is_self == true)
                    ? Get.isDarkMode
                        ? Theme.of(context).primaryColorLight
                        : CprimaryLight
                    : Get.isDarkMode
                        ? Theme.of(context).primaryColorLight
                        : const Color.fromARGB(255, 198, 198, 198),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  textDirection: TextDirection.rtl,
                  "$message",
                  textAlign: TextAlign.right,
                ),
                Opacity(
                  opacity: .5,
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "$time",
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 30,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            is_read != null
                                ? const Icon(
                                    Icons.check_outlined,
                                    size: 15,
                                  )
                                : const SizedBox(),
                            Positioned(
                              right: 5,
                              child: (is_read == true)
                                  ? const Icon(
                                      Icons.check_outlined,
                                      size: 15,
                                    )
                                  : const SizedBox(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ChatHeaderCard

class ChatHeaderCard extends StatelessWidget {
  String text;
  String? image;
  Function() onTap;
  ChatHeaderCard(
      {required this.text, this.image, super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: Get.width - 20,
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 35,
                offset: const Offset(0, 10),
              ),
            ],
            color: Theme.of(context).primaryColorLight,
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              image == null
                  ? Container(
                      height: 50,
                      width: 50,
                      color: Colors.grey.withOpacity(.5),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Theme.of(context).cardColor.withOpacity(.5),
                      ),
                    )
                  : Image.network(
                      image!,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(
                width: 10,
              ),
              Text("$text")
            ],
          ),
        ),
      ),
    );
  }
}

// ChatTextField

class ChatTextField extends StatelessWidget {
  Function? on_send_click;
  ChatTextField({this.on_send_click, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).primaryColorLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 35,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          const SizedBox(
            width: 20,
          ),
          InkWell(
            child: Icon(
              Icons.send_outlined,
              color: Cprimary,
            ),
            onTap: () {
              if (this.on_send_click != null) {
                this.on_send_click!();
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 2,
            height: 20,
            color: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: TextField(
            textDirection: TextDirection.rtl,
            maxLines: null,
            autofocus: true,
            controller: Get.find<ChatController>().chatTextField,
            cursorColor: Colors.grey,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "چیزی بنویسید ...",
                hintTextDirection: TextDirection.rtl,
                hintStyle: TextStyle(fontSize: 15)),
          )),
        ],
      ),
    );
  }
}

// ChatListItem

class ChatListItem extends StatelessWidget {
  String? time;
  String? text_title;
  String? text_item;
  bool? is_pin = false;
  Function()? func;
  int unreadCount;
  Widget image;
  ChatListItem(
      {this.func,
      this.time,
      this.is_pin,
      this.text_item,
      this.text_title,
      required this.image,
      required this.unreadCount,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        width: Get.width,
        height: 55,
        decoration: BoxDecoration(
            boxShadow: [bs010],
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(10),
            border: (is_pin == true) ? Border.all(color: Cprimary) : null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    color: Colors.grey,
                    margin: const EdgeInsets.all(5),
                    width: 40,
                    height: 60,
                    child: image,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$text_title",
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      maxLines: 1,
                      "$text_item",
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                textDirection: TextDirection.rtl,
                children: [
                  (is_pin == true)
                      ? const Icon(
                          Icons.push_pin_rounded,
                          size: 16,
                        )
                      : unreadCount == 0
                          ? const SizedBox()
                          : SizedBox(
                              width: 20,
                              height: 20,
                              child: CircleAvatar(
                                backgroundColor: Cprimary,
                                child: Text(
                                  unreadCount.toString().toFarsi(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Cwhite,
                                      fontFamily: 'iransans'),
                                ),
                              ),
                            ),
                  Text(
                    "$time",
                    style: const TextStyle(fontSize: 10),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// AppBarSearch

class AppBarSearch extends StatelessWidget {
  const AppBarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 50,
      color: Cprimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 1,
          ),
          Icon(
            Icons.arrow_back,
            color: Cwhite,
            size: 25,
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(7),
            width: Get.width - 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColorLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  blurRadius: 35,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Expanded(
              child: TextField(
                cursorColor: Colors.grey,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "جستجو در دسته بندی",
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PlanCard

class PlanCard extends StatefulWidget {
  PlanModel? pm;
  PlanCard({required this.pm, super.key});

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  var manageadscontroller = Get.find<ManagerAdsController>();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    if (manageadscontroller.selectedPlans.value == widget.pm) {
      isChecked = true;
    } else {
      isChecked = false;
    }
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: Get.width,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          boxShadow: [bs010],
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Cprimary,
                  value: isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      manageadscontroller.priceValue.value = widget.pm!.price!;
                      manageadscontroller.selectedPlans(widget.pm!);
                    } else {
                      manageadscontroller.priceValue.value = 0;
                      manageadscontroller.selectedPlans(PlanModel());
                    }
                    manageadscontroller.listPlans.refresh();
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                ),
                Text(
                  "${widget.pm?.name}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50, top: 5),
            child: Text(
              "${widget.pm?.price} تومان",
              style: const TextStyle(fontSize: 15),
              textDirection: TextDirection.rtl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20, left: 10),
            child: Text(
              "${widget.pm?.description}",
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCardSubmit extends StatefulWidget {
  PlanModel? pm;
  PlanCardSubmit({required this.pm, super.key});

  @override
  State<PlanCardSubmit> createState() => _PlanCardSubmitState();
}

class _PlanCardSubmitState extends State<PlanCardSubmit> {
  var addadscontroller = Get.find<AddAdsController>();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    if (addadscontroller.listSelectedPlans.contains(widget.pm)) {
      isChecked = true;
    }
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: Get.width,
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          boxShadow: [bs010],
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: Cprimary,
                  value: isChecked,
                  onChanged: (value) {
                    if (value == true) {
                      addadscontroller.priceValue + widget.pm!.price!;
                      addadscontroller.listSelectedPlans.add(widget.pm!);
                    } else {
                      addadscontroller.priceValue - widget.pm!.price!;
                      addadscontroller.listSelectedPlans.remove(widget.pm!);
                    }
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                ),
                Text(
                  "${widget.pm?.name}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50, top: 5),
            child: Text(
              "${widget.pm?.price} تومان",
              style: const TextStyle(fontSize: 15),
              textDirection: TextDirection.rtl,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20, left: 10),
            child: Text(
              "${widget.pm?.description}",
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

void unFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showBottomSheetExample(BuildContext context, onTap, chatid) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ListTile(
                  title: const Text('حذف'),
                  // Replace with the actual phone number
                  leading: const Icon(Icons.delete_forever),
                  onTap: onTap),
            ],
          ),
        ),
      );
    },
  );
}
