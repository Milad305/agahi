import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:uni_links/uni_links.dart';

class ContextUtility {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'ContextUtilityNavigatorKey');
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static bool get hasNavigator => navigatorKey.currentState != null;
  static NavigatorState? get navigator => navigatorKey.currentState;

  static bool get hasContext => navigator?.overlay?.context != null;
  static BuildContext? get context => navigator?.overlay?.context;
}

/* class UniLinksService {
  static String _promoId = '';

  static void reset() => _promoId = '';

  static Future<void> init({checkActualVersion = false}) async {
    // This is used for cases when: APP is not running and the user clicks on a link.
    try {
      final Uri? uri = await getInitialUri();
      Get.put(MainController());
      Get.find<MainController>().uniloaded.value = true;
      _uniLinkHandler(uri: uri);
    } on PlatformException {
      if (kDebugMode)
        print("(PlatformException) Failed to receive initial uri.");
    } on FormatException catch (error) {
      if (kDebugMode)
        print(
            "(FormatException) Malformed Initial URI received. Error: $error");
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    uriLinkStream.listen((Uri? uri) async {
      _uniLinkHandler(uri: uri);
    }, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error');
    });
  }

  static Future<void> _uniLinkHandler({required Uri? uri}) async {
    if (uri == null) return;

    Get.put(AddAdsController());
    Get.put(MainController());

    // Handle your deep link here

    await Get.find<MainController>()
        .getAdsById(int.parse(uri.pathSegments.last));



  }
}
 */