import 'package:agahi_app/api/firebase_api.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/constant/thememanager.dart';
/* import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/screens/show_ads_screen.dart'; */
import 'package:agahi_app/utils/contect_utility.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
/* import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException; */
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'ScrollBehavior.dart';
import 'constant/bindings.dart';
import 'routes/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    // 'resource://drawable/res_app_icon',
    null,
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Cprimary,
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  await Firebase.initializeApp();
  await FireBaseApi().initNotifications();
  await GetStorage.init('agahi');

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  //ADD THIS FUNCTION TO HANDLE DEEP LINKS
  /*Future<Null> initUniLinks() async {
    try {
      Uri? initialLink = await getInitialUri();
      Get.put(AddAdsController());
      Get.put(MainController());
      
      // Handle your deep link here
      initialLink != null
          ?  await Get.find<MainController>()
              .getAdsById(int.parse(initialLink.pathSegments.last))
          : null;
    
      //print('Deep link received: /product/${deepLink.pathSegments.last}');
    } on PlatformException {
      print('platfrom exception unilink');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    //  initUniLinks();
    return GetMaterialApp(
      navigatorKey: ContextUtility.navigatorKey,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      initialBinding: MyBindings(),
      initialRoute: '/splash',
      getPages: Routes.page,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
