// ignore_for_file: must_be_immutable

import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../constant/classess.dart';
import '../constant/colors.dart';

class SubmitTextFieldWidget extends StatelessWidget {
  SubmitTextFieldWidget({
    this.title,
    this.controller,
    this.height,
    this.hint,
    this.inputType,
    this.textInputFormatter,
    this.maxline,
    this.maxlength,
    this.isRequired = false,
    this.counterText,
    this.color,
    this.onChange,
    super.key,
  });
  final String? title;
  final String? hint;
  final isRequired;
  final double? height;
  final int? maxlength;
  Color? color;
  final TextEditingController? controller;
  final String? counterText;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatter;
  final int? maxline;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        isRequired
            ? const Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
            : SizedBox(),
        title == null
            ? const SizedBox()
            : SizedBox(width: Get.width * .2, child: Text(title!)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextField(
                inputFormatters: textInputFormatter,
                keyboardType: inputType,
                onSubmitted: (value) {
                  value != null && value != '' ? color = Colors.black87 : null;
                },
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                controller: controller,
                enableInteractiveSelection: true,
                textAlign: TextAlign.center,
                maxLines: maxline ?? 1,
                onChanged: onChange,
                maxLength: maxlength ?? 100,
                decoration: InputDecoration(
                  counterText: counterText ?? '',
                  hintText: hint,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.only(bottom: 7, top: 7),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color ?? Colors.black87)),
                )))
      ]),
    );
  }
}

//  dialogue cancel massage
class DialogueCancelMassage extends StatelessWidget {
  String text;
  Function()? deletefunc;

  DialogueCancelMassage({required this.text, this.deletefunc, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: .2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
              width: 35,
              height: 35,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: CRedLight),
              child: Icon(
                Icons.delete,
                color: CRed,
                size: 25,
              )),
          const SizedBox(
            height: 15,
          ),
          Text(text),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonsDialogue(
                func: () {
                  Get.back();
                },
                boxShadow: [bs010],
                text: "انصراف",
                width: 80,
                height: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              ButtonsDialogue(
                func: deletefunc,
                is_red: true,
                boxShadow: [bs010red],
                bg_color: CRedLight,
                text_color: CRed,
                text: "تایید",
                width: 80,
                height: 30,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

// ButtonsDialogue
class ButtonsDialogue extends StatelessWidget {
  List<BoxShadow>? boxShadow;
  bool? is_red;
  double? fontSize_text;
  double? borderRadius;
  double? width;
  double? height;
  Color? text_color;
  Color? bg_color;
  String text;
  Function()? func;
  ButtonsDialogue({
    required this.text,
    this.text_color,
    this.is_red,
    this.func,
    this.boxShadow,
    this.fontSize_text,
    this.borderRadius,
    this.height,
    this.width,
    this.bg_color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
          alignment: Alignment.center,
          width: width ?? Get.width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 15),
              boxShadow: boxShadow,
              color: is_red == true
                  ? CRedLight
                  : Theme.of(context).primaryColorLight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: text_color ?? Theme.of(context).cardColor,
                    fontSize: fontSize_text ?? 13),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}
//  dialogue cancel massage

// *********************************
// box agahi
class BoxAgahi extends StatelessWidget {
  String title;
  String text_dovom;
  double? fontSize;
  String text_qeymat;
  String text_date;
  String? image;
  double? left_right;
  Function()? func;
  int? myadsstatus;
  String? statusMessage;
  bool isLadder;
  bool? isForce;
  BoxAgahi(
      {required this.title,
      this.fontSize,
      required this.text_dovom,
      required this.text_qeymat,
      required this.text_date,
      required this.isLadder,
      this.image,
      this.left_right,
      this.func,
      this.myadsstatus,
      this.statusMessage,
      this.isForce,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Padding(
        padding: EdgeInsets.only(
            left: left_right ?? 10,
            right: left_right ?? 10,
            top: left_right == null ? 10 : (left_right! * .5)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: Get.width,
            height: 130,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              boxShadow: [bs010],
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: fontSize ?? 15),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            text_dovom,
                            style: TextStyle(
                                color: Theme.of(context).highlightColor,
                                fontSize: fontSize ?? 13),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            text_qeymat,
                            style: TextStyle(fontSize: fontSize ?? 13),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              isForce == true
                                  ? Container()
                                  : Text(
                                      text_date,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).highlightColor,
                                          fontSize: fontSize ?? 13),
                                    ),
                              const Spacer(),
                              isLadder
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Cprimary),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: const Text('نردبان',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )
                                  : Container(),
                              myadsstatus == null
                                  ? isForce == true
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Cprimary),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: const Text('فوری',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      : const SizedBox()
                                  : TextButton(
                                      clipBehavior: Clip.none,
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          minimumSize: Size(100, 50),
                                          padding: EdgeInsets.zero,
                                          foregroundColor: myadsstatus == 2
                                              ? Theme.of(context)
                                                  .cardColor
                                                  .withOpacity(.5)
                                              : Theme.of(context).cardColor),
                                      onPressed: myadsstatus == 2
                                          ? () {
                                              ApiProvider()
                                                  .dialogMyAds(statusMessage!);
                                            }
                                          : null,
                                      child: Row(
                                        children: [
                                          myadsstatus ==
                                                  MyAdsStatus.rejected.index
                                              ? Icon(
                                                  size: 18,
                                                  Icons.cancel,
                                                  color: CerrorColor,
                                                )
                                              : myadsstatus ==
                                                      MyAdsStatus.waiting.index
                                                  ? Icon(
                                                      size: 18,
                                                      Icons.error,
                                                      color: CwarningColor,
                                                    )
                                                  : myadsstatus ==
                                                          MyAdsStatus
                                                              .accepted.index
                                                      ? Icon(
                                                          size: 18,
                                                          Icons.verified,
                                                          color: CsuccessColor,
                                                        )
                                                      : myadsstatus ==
                                                              MyAdsStatus
                                                                  .waiting.index
                                                          ? Icon(
                                                              size: 18,
                                                              Icons.error,
                                                              color:
                                                                  CwarningColor,
                                                            )
                                                          : myadsstatus ==
                                                                  MyAdsStatus
                                                                      .pending
                                                                      .index
                                                              ? Icon(
                                                                  size: 18,
                                                                  Icons.error,
                                                                  color:
                                                                      CwarningColor,
                                                                )
                                                              : const SizedBox(),
                                          Text(myadsstatus ==
                                                  MyAdsStatus.waiting.index
                                              ? 'در انتظار تایید'
                                              : myadsstatus ==
                                                      MyAdsStatus.accepted.index
                                                  ? 'تایید شده'
                                                  : myadsstatus ==
                                                          MyAdsStatus
                                                              .rejected.index
                                                      ? 'رد شده'
                                                      : myadsstatus ==
                                                              MyAdsStatus
                                                                  .pending.index
                                                          ? 'در‌انتظار‌‌‌پرداخت'
                                                          : ''),
                                        ],
                                      ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width: 130,
                    height: 130,
                    child: image == null
                        ? Container(
                            color: Colors.grey.withOpacity(.5),
                            child: Icon(
                              Icons.image_not_supported,
                              color:
                                  Theme.of(context).cardColor.withOpacity(.5),
                            ),
                          )
                        : Image.network(
                            image!,
                            fit: BoxFit.cover,
                          )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// *********************************
class CodeTextField extends StatelessWidget {
  int? maxLength;
  String? hintText;
  TextEditingController? controller;
  CodeTextField({
    this.maxLength,
    this.hintText,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).primaryColorLight,
        boxShadow: [bs010],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        showCursor: false,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        decoration: InputDecoration(
            counter: const SizedBox(),
            border: InputBorder.none,
            hintText: hintText),
      ),
    );
  }
}

// *********************************
// BtnLogin
class BtnLogin extends StatelessWidget {
  bool is_login;
  Function()? func;
  BtnLogin({
    required this.is_login,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: is_login ? CRedLight : Cprimary,
            foregroundColor: is_login ? CRed : Cwhite,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        onPressed: func,
        child: Text(is_login ? 'خروج از حساب' : 'ورود'));
  }
}

// ******************************************
// payments
class Payments extends StatelessWidget {
  String price;
  double? borderRadius_container;
  String date;
  String time;
  Icon? icon;
  String agahi;
  Payments(
      {required this.price,
      required this.date,
      this.icon,
      this.borderRadius_container,
      required this.time,
      required this.agahi,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius_container ?? 10),
        color: Theme.of(context).primaryColorLight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                    color: Theme.of(context).highlightColor.withOpacity(.7)),
              ),
              Row(
                children: [
                  Text(
                    agahi,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  icon!,
                ],
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                    color: Theme.of(context).highlightColor.withOpacity(.7)),
              ),
              Text(
                price,
                textDirection: TextDirection.rtl,
              )
            ],
          ),
        ],
      ),
    );
  }
}

// **************************************
// textfeild support
class TextFeildSupport extends StatelessWidget {
  String? hintText;
  double? height;
  int? maxLines;
  TextEditingController? controller;
  TextFeildSupport({this.controller, this.hintText, this.maxLines, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        boxShadow: [bs010],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

//
class ContainerFile extends StatelessWidget {
  double? borderRadius_button;
  double? borderRadius_container;
  String text;
  double? fontSize;
  Function? on_click;
  ContainerFile(
      {this.borderRadius_button,
      this.fontSize,
      this.borderRadius_container,
      this.on_click,
      required this.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 8, top: 5, bottom: 5),
      decoration: BoxDecoration(
        boxShadow: [bs010],
        borderRadius: BorderRadius.circular(borderRadius_container ?? 10),
        color: Theme.of(context).primaryColorLight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonAgahi(
            padding: const EdgeInsets.only(top: 8),
            width: 90,
            decoration: BoxDecoration(
                color: Cprimary,
                borderRadius: BorderRadius.circular(borderRadius_button ?? 10)),
            child: Text(
              "انتخاب",
              textAlign: TextAlign.center,
              style: TextStyle(color: Cwhite),
            ),
            func: () {
              if (on_click != null) on_click!();
            },
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: fontSize ?? 15),
          ),
        ],
      ),
    );
  }
}
