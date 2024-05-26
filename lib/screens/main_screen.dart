import 'dart:async';

import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/payment_controller.dart';
import 'package:agahi_app/screens/account_screen.dart';
import 'package:agahi_app/screens/add_ads_screen.dart';
import 'package:agahi_app/screens/ads_screen.dart';
import 'package:agahi_app/screens/category_screen.dart';
import 'package:agahi_app/screens/chat_list_screen.dart';
import 'package:agahi_app/screens/guest_chat_screen.dart';
import 'package:agahi_app/screens/manage_ads_screen.dart';
import 'package:agahi_app/screens/my_payments_screen.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
import '../constant/strings.dart';
import '../controller/add_ads_controller.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // maincontroller.checkVersion();
    });
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  var maincontroller = Get.find<MainController>();
  bool isHomeScreenLoaded = false;
  bool isDeepLinkHandled = false;
  Uri? pendingDeepLink;
  DateTime? _lastPressedAt;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    //_initUniLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

/*
  Future<void> _initUniLinks() async {
    try {
      final Uri? uri = await getInitialUri();
      if (uri != null) {
        pendingDeepLink = uri;
      }
    } on PlatformException {
      if (kDebugMode)
        print("(PlatformException) Failed to receive initial uri.");
    } on FormatException catch (error) {
      if (kDebugMode)
        print(
            "(FormatException) Malformed Initial URI received. Error: $error");
    }

    uriLinkStream.listen((Uri? uri) {
      if (isHomeScreenLoaded) {
        _handleDeepLink(uri);
      } else {
        pendingDeepLink = uri;
      }
    }, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error');
    });
  }

  Future<void> _handleDeepLink(Uri? uri) async {
    if (uri == null || isDeepLinkHandled) return;

    // Handle your deep link here
    if (uri.path.contains('/ads/')) {
      // Handle /ads/ deep links
      Get.put(AddAdsController());
      Get.put(MainController());

      await Get.find<MainController>()
          .getAdsById(int.parse(uri.pathSegments.last));
    } else if (uri.path.contains('/verify/')) {
      Get.put(PaymentController());
      Get.to(PaymentsScreen());
      // Handle /verify/ deep links
    } else {
      // Handle other deep links
    }

    // Mark deep link as handled
    isDeepLinkHandled = true;
  }
*/
  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarIsOpen =
        _lastPressedAt == null ||
            currentTime.difference(_lastPressedAt!) > Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarIsOpen) {
      _lastPressedAt = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('جهت خروج دوبار فشار دهید')),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      isHomeScreenLoaded = true;
      if (pendingDeepLink != null && !isDeepLinkHandled) {
        // If there's a pending deep link and it hasn't been handled yet,
        // handle it now that the home screen is loaded
        // _handleDeepLink(pendingDeepLink!);
        pendingDeepLink = null; // Clear pending deep link
      }
    });

    return SafeArea(
        child: WillPopScope(
      onWillPop: _onWillPop,
      child: CustomScaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            height: 55,
            width: Get.width,
            decoration: BoxDecoration(
                boxShadow: [bs010r],
                color: Theme.of(context).primaryColorLight),
            child: Obx(() => Row(
                  textDirection: TextDirection.rtl,
                  children: addBottomNavBar(),
                )),
          ),
        ),
        body: Column(
          children: [
            /*Obx(() {
              return Get.find<MainController>().isinternet.value == false
                  ? OflineMessage()
                  : Container();
            }),*/
            SizedBox(
              width: Get.width,
              height: Get.height - 83,
              child: Obx(() => IndexedStack(
                      index: maincontroller.bottomindex.value,
                      children: [
                        AdsScreen(),
                        CategoryScreen(),
                        AddAdsScreen(),
                        maincontroller.isLoggedIn.value
                            ? const ChatListScreen()
                            : const GuestLoginScreen(),
                        AccountScreen()
                      ])),
            ),
          ],
        ),
      ),
    ));
  }
}

class BottomNavBarItem extends StatelessWidget {
  final bool? isMain;
  final bool? isSelected;
  final IconData? icondata;
  final String? text;
  final Function()? func;
  const BottomNavBarItem(
      {this.isMain,
      this.isSelected,
      this.icondata,
      this.text,
      this.func,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
      onTap: func,
      borderRadius: BorderRadius.circular(30),
      child: Container(
          color:
              isMain == true ? Cprimary : Theme.of(context).primaryColorLight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 3,
              ),
              Expanded(
                flex: 5,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                        color: isSelected == true || isMain == true
                            ? Cprimary
                            : Theme.of(context).hintColor,
                        shape: BoxShape.circle),
                    child: Center(
                      child:
                          // iconSize: 25,
                          //   splashRadius: 18,
                          isSelected == true || isMain == true
                              ? Icon(
                                  icondata,
                                  color: Cwhite,
                                )
                              : Icon(icondata),
                    )),
              ),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      text ?? '',
                      style: isMain == true
                          ? TextStyle(fontSize: 11, color: Cwhite)
                          : isSelected == true && !Get.isDarkMode
                              ? TextStyle(fontSize: 11, color: Cprimary)
                              : const TextStyle(fontSize: 11),
                    ),
                  ))
            ],
          )),
    ));
  }
}

addBottomNavBar() {
  var homecontroller = Get.find<MainController>();
  var addadscontroller = Get.find<AddAdsController>();
  List<Widget> lst = [];

  for (int i = 0; i <= 4; i++) {
    if (i == 2) {
      lst.add(BottomNavBarItem(
        isMain: true,
        text: names[i],
        icondata: icondatas[i],
        func: () {
          Timer(Duration.zero, () {
            if (Get.find<MainController>().isLoggedIn.value) {
              bottomNavItemFunc(i);
              addadscontroller.isCanBack(true);
            } else {
              Get.toNamed('/phonenumber');
            }
          });
        },
      ));
    } else if (i == homecontroller.bottomindex.value) {
      lst.add(BottomNavBarItem(
          isSelected: true,
          text: names[i],
          icondata: icondatas[i],
          func: () {
            Timer(Duration.zero, () {
              bottomNavItemFunc(i);
            });
          }));
    } else {
      lst.add(BottomNavBarItem(
          isSelected: false,
          text: names[i],
          icondata: icondatas[i],
          func: () {
            Timer(Duration.zero, () {
              bottomNavItemFunc(i);
            });
          }));
    }
  }

  return lst;
}

void bottomNavItemFunc(int index) {
  var maincontroller = Get.find<MainController>();
  maincontroller.bottomindex(index);
  switch (index) {
    case 0:
      {
        //agahi
        Get.find<CitySearchController>().selectedcat.value = -1;
        maincontroller.getAds();
        maincontroller.getCategory();
        break;
      }
    case 1:
      {
        //category
        maincontroller.isShowChild(false);
        break;
      }
    case 2:
      {
        //addads

        Get.find<AddAdsController>().getCategory();

        break;
      }
    case 3:
      {
        //chats
        if (maincontroller.isLoggedIn.value) {
          Get.find<ChatController>().getRooms();
        }
        break;
      }
    default:
  }
}
