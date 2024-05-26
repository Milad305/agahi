import 'dart:async';

import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdditionalFieldsModel.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/screens/ads_screen.dart';
import 'package:agahi_app/screens/category_ads.dart';
import 'package:agahi_app/screens/main_screen.dart';
import 'package:agahi_app/screens/owner_ads_screen.dart';
import 'package:agahi_app/utils/widget_generator.dart';
import 'package:agahi_app/widget/dialog_note.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' as intl;
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api.dart';
import '../widget/widget.dart';

class ShowAdsScreen extends GetView<MainController> {
  bool isPreview;
  ShowAdsScreen({Key? key, required this.ads, this.isPreview = false}) {
    var maincontroller = Get.find<MainController>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      maincontroller.userReaction.value =
          GetStorage().read('reaction_${ads.id}') ?? -1;
      isPreview ? maincontroller.addView(ads.id) : null;
      if (maincontroller.isLoggedIn.value) {
        maincontroller.checkBookmarkAds();
        maincontroller.getAdsByOwner();
      }
    });
  }

  AdsModel ads;
  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();

    //AdsModel ad = maincontroller.adsModel.value;
    maincontroller.currentPositionPic(0);
    DateTime originalDateTime = DateTime.parse(ads.createdAt!);

    String formattedDateTime =
        intl.DateFormat('yyyy/MM/dd').format(originalDateTime);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // Get.to(() => AdsScreen());
        }
      },
      child: SafeArea(
        child: CustomScaffold(
          appBar: AppBar(
            backgroundColor: Cprimary,
            foregroundColor: Cwhite,
            leading: IconButton(
                highlightColor: Cwhite.withOpacity(.5),
                splashRadius: 20,
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back)),
            title: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  ads.title!,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* Obx(() {
                  return Get.find<MainController>().isinternet.value == false
                      ? OflineMessage()
                      : Container();
                }),*/
                Expanded(
                  child: ListView(
                    children: [
                      ads.images?.length == 0
                          ? Container(
                              height: 150,
                              width: Get.width,
                              color: Colors.grey.withOpacity(.5),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      color: Colors.white,
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          'assets/images/ic_logo.jpg',
                                          opacity:
                                              const AlwaysStoppedAnimation(.4),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  BookmarkWidget(
                                      maincontroller: maincontroller),
                                  NoteWidget(maincontroller: maincontroller),
                                  shareWidget(maincontroller: maincontroller),
                                ],
                              ),
                            )
                          : ads.images?.length == 1
                              ? SizedBox(
                                  height: Get.width * .8,
                                  width: Get.width * .8,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                          //width: Get.width * .8,
                                          height: Get.width * .8,
                                          fit: BoxFit.fill,
                                          '${ApiProvider().domain}${ads.images![0].image}'),
                                      Positioned(
                                          bottom: 0,
                                          child: Container(
                                            height: 35,
                                            width: Get.width,
                                            color: const Color.fromARGB(
                                                186, 0, 0, 0),
                                          )),
                                      BookmarkWidget(
                                          maincontroller: maincontroller),
                                      NoteWidget(
                                          maincontroller: maincontroller),
                                      shareWidget(
                                          maincontroller: maincontroller),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: Get.width * .8,
                                  width: Get.width * .8,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: Get.width,
                                        height: Get.width,
                                        child: CarouselSlider.builder(
                                          itemCount: ads.images!.length,
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            return Image.network(
                                                width: Get.width,
                                                height: Get.width,
                                                fit: BoxFit.cover,
                                                '${ApiProvider().domain}${ads.images![index].image}');
                                          },
                                          disableGesture: true,
                                          options: CarouselOptions(
                                              onPageChanged: (index, reason) {
                                                maincontroller
                                                    .currentPositionPic(index);
                                              },
                                              aspectRatio: 1,
                                              enlargeFactor: 1,
                                              autoPlay: false,
                                              reverse: true,
                                              enableInfiniteScroll: false,
                                              enlargeCenterPage: true),
                                        ),
                                      ),

                                      BookmarkWidget(
                                          maincontroller: maincontroller),
                                      NoteWidget(
                                          maincontroller: maincontroller),
                                      shareWidget(
                                          maincontroller: maincontroller),
                                      //create a dot indicator for images
                                      Positioned(
                                        bottom: 0,
                                        child: Obx(() => Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: DotsIndicator(
                                                dotsCount: ads.images!.length,
                                                position: maincontroller
                                                    .currentPositionPic.value,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('تاریخ ثبت آگهی'),
                                    Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Text(ads.ladder_time
                                                .toString()
                                                .get_created_at() ??
                                            ''))
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 5,
                              color:
                                  Theme.of(context).cardColor.withOpacity(.2),
                              thickness: 0.5,
                            ),
                            SizedBox(
                              height: 35,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('دسته'),
                                    GestureDetector(
                                      onTap: () {
                                        maincontroller.bottomindex(0);
                                        Get.find<MainController>()
                                            .getMyAdsFitlerByCategorymain(
                                                ads.category!.id!);
                                        Get.offAll(MainScreen());
                                        /* Get.to(CatAdsPage(
                                            catIndex: ads.category!.id!,
                                            catTitle: ads.category!.name!));*/
                                      },
                                      child: Text(
                                        ads.category!.name ?? '',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              height: 5,
                              color:
                                  Theme.of(context).cardColor.withOpacity(.2),
                              thickness: 0.5,
                            ),
                            SizedBox(
                              height: 35,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('قیمت'),
                                  Text(ads.getprice() ?? '')
                                ],
                              ),
                            ),
                            Divider(
                              height: 5,
                              color:
                                  Theme.of(context).cardColor.withOpacity(.5),
                              thickness: 1,
                            )
                          ],
                        ),
                      ),
                      ColumnBuilder(
                          itemBuilder: (context, index) {
                            AdditionalFields? adf =
                                ads.additionalFields?[index];
                            return adf?.value == null || adf?.value == ''
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(adf?.label ?? ''),
                                            Text(adf?.value ?? '')
                                          ],
                                        ),
                                        Divider(
                                          height: 5,
                                          color: Theme.of(context)
                                              .cardColor
                                              .withOpacity(.2),
                                          thickness: 1,
                                        )
                                      ],
                                    ),
                                  );
                          },
                          itemCount: ads.additionalFields!.length),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Cprimary,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'توضیحات',
                                  style: TextStyle(color: Cwhite),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                ads.description ?? '',
                              ),
                              Divider(),
                              maincontroller.canSetReaction()
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("امتیاز به این آگهی"),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.thumb_up),
                                              color: controller
                                                          .userReaction.value ==
                                                      1
                                                  ? Colors.blue
                                                  : null,
                                              onPressed: () => controller
                                                  .setReaction(1, ads: ads),
                                            ),
                                            IconButton(
                                              icon:
                                                  const Icon(Icons.thumb_down),
                                              color: controller
                                                          .userReaction.value ==
                                                      0
                                                  ? Colors.red
                                                  : null,
                                              onPressed: () => controller
                                                  .setReaction(0, ads: ads),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("امتیاز آگهی"),
                                        Row(
                                          children: [
                                            Text(
                                              "${ads.likes ?? 0} : ",
                                            ),
                                            const Icon(
                                              Icons.thumb_up,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "${ads.deslikes ?? 0} : ",
                                            ),
                                            const Icon(
                                              Icons.thumb_down,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              Divider(),
                            ],
                          );
                        }),
                      ),
                      Obx(
                        () => maincontroller.isLoadingOwnerAds.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Cprimary,
                                ),
                              )
                            : maincontroller.listOwenerAds.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => OwnerAdsScreen());
                                          },
                                          child: const Text(
                                            "آگهی های کاربر",
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ads.lang != 0.0 && ads.lat != null
                          ? Container(
                              height: 200,
                              width: Get.width,
                              child: LocationPicker(
                                adsloc: LatLng(ads.lat!, ads.lang!),
                                onlyShow: true,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                /*   maincontroller.adsModel.value.owner!.id ==
                        maincontroller.profile.value.id
                    ? const SizedBox()
                    :  */

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  width: Get.width,
                  child: ads.contact == ContactRadioList.chat.index
                      ? Row(
                          children: [
                            Container(
                              width: Get.width * .5,
                              height: 100,
                              child: Text("شماره مخفی شده است ,پیام دهید."),
                            ),
                            Container(
                              width: Get.width * .4,
                              height: 100,
                              child: PrimaryTextButton(
                                  crl: ContactRadioList.chat.index, ad: ads),
                            ),
                          ],
                        )
                      : ads.contact == ContactRadioList.call.index
                          ? PrimaryTextButton(
                              crl: ContactRadioList.call.index, ad: ads)
                          : Row(
                              children: [
                                Expanded(
                                    child: PrimaryTextButton(
                                        crl: ContactRadioList.chat.index,
                                        ad: ads)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: PrimaryTextButton(
                                        crl: ContactRadioList.call.index,
                                        ad: ads))
                              ],
                            ),
                ),
                //map
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchTheUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

class NoteWidget extends StatelessWidget {
  const NoteWidget({
    super.key,
    required this.maincontroller,
  });

  final MainController maincontroller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: Get.width * .1,
      child: IconButton(
          highlightColor: Cwhite.withOpacity(.5),
          splashRadius: 20,
          onPressed: () {
            if (maincontroller.isLoggedIn.value) {
              showDialog(
                context: context,
                builder: (context) {
                  maincontroller.textFieldDialogNote.clear();
                  return const DialogNote();
                },
              );
            } else {
              Get.toNamed('/phonenumber');
            }
          },
          icon: Icon(
            Icons.note_add_sharp,
            color: Cprimary,
          )),
    );
  }
}

class shareWidget extends StatelessWidget {
  const shareWidget({
    super.key,
    required this.maincontroller,
  });

  final MainController maincontroller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: Get.width * .18,
      child: IconButton(
          highlightColor: Cwhite.withOpacity(.5),
          splashRadius: 20,
          onPressed: () {
            Share.share('${maincontroller.adsModel.value.link}');

            /* if (maincontroller.isLoggedIn.value) {
              showDialog(
                context: context,
                builder: (context) {
                  maincontroller.textFieldDialogNote.clear();
                  return const DialogNote();
                },
              );
            } else {
              Get.toNamed('/phonenumber');
            }*/
          },
          icon: Icon(Icons.share, color: Cprimary)),
    );
  }
}

class BookmarkWidget extends StatelessWidget {
  const BookmarkWidget({
    super.key,
    required this.maincontroller,
  });

  final MainController maincontroller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: Get.width * .03,
      child: Obx(() => maincontroller.isLoadingBookmark.value
          ? Center(
              child: CircularProgressIndicator(
                color: Cwhite,
                strokeWidth: 1,
              ),
            )
          : maincontroller.isBookmarked.value
              ? IconButton(
                  highlightColor: Cwhite.withOpacity(.5),
                  splashRadius: 20,
                  onPressed: () {
                    maincontroller.bookmarkAds();
                  },
                  icon: Icon(Icons.bookmark, color: Cprimary))
              : IconButton(
                  highlightColor: Cwhite.withOpacity(.5),
                  splashRadius: 20,
                  onPressed: () {
                    maincontroller.bookmarkAds();
                  },
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Cprimary,
                  ))),
    );
  }
}

class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton({required this.crl, required this.ad, Key? key})
      : super(key: key);
  final int? crl;
  final AdsModel? ad;

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    var chatcontroller = Get.find<ChatController>();
    return TextButton(
        style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Cprimary,
            foregroundColor: Cwhite),
        onPressed: () {
          if (ContactRadioList.call.index == crl) {
            showBottomSheetExample(context, () {
              launchUrl(Uri.parse('tel:${ad?.owner?.username}'));
            }, ad?.owner?.username);
          } else {
            chatcontroller.selectedAd(maincontroller.adsModel.value);
            chatcontroller
                .selectedChatId(chatcontroller.selectedAd.value.chatId);
            Get.toNamed('/chat');
          }
        },
        child: ContactRadioList.call.index == crl
            ? const Text('تماس')
            : const Text('چت'));
  }
}

void showBottomSheetExample(BuildContext context, onTap, phone) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -120,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 100,
                  width: Get.width * .97,
                  child: const Text(
                      "هشدار پلیس و قضایی: لطفا پیش از انجام معامله و هر نوع پرداخت وجه, از صحت کالا یا خدمات ارائه شده به صورت حضوری اطمینان حاصل نمایید."),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اطلاعات تماس',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                      title: const Text('تماس'),
                      subtitle: Text(phone
                          .toString()), // Replace with the actual phone number
                      leading: const Icon(Icons.phone),
                      onTap: onTap),
                  ListTile(
                      title: const Text('ارسال پیام'),
                      subtitle: Text(phone
                          .toString()), // Replace with the actual phone number
                      leading: const Icon(Icons.sms_rounded),
                      onTap: () async {
                        launchMessage(phone.toString());
                      }),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

launchMessage(String phoneNumber) async {
  final Uri uri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );
  final String uriString = uri.toString();

  if (await canLaunch(uriString)) {
    await launch(uriString);
  } else {
    throw 'Could not launch $uriString';
  }
}
