import 'package:agahi_app/screens/chatNotificationScreen.dart';
import 'package:agahi_app/screens/edit_ads.dart';
import 'package:agahi_app/screens/recent_view_screen.dart';
import 'package:agahi_app/screens/bookmark_and_notes.dart';
import 'package:agahi_app/screens/chat_screen.dart';
import 'package:agahi_app/screens/confirm_code_screen.dart';
import 'package:agahi_app/screens/manage_ads_screen.dart';
import 'package:agahi_app/screens/my_ads.dart';
import 'package:agahi_app/screens/my_payments_screen.dart';
import 'package:agahi_app/screens/our_rules_screen.dart';
import 'package:agahi_app/screens/plans_screen.dart';
import 'package:agahi_app/screens/questions_screen.dart';
import 'package:agahi_app/screens/city_search_screen.dart';
import 'package:agahi_app/screens/send_code_screen.dart';
import 'package:agahi_app/screens/setting_screen.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:agahi_app/screens/splash_screen.dart';
import 'package:agahi_app/screens/submit_ads_screen.dart';
import 'package:agahi_app/screens/support_screen.dart';
import 'package:get/get.dart';
import '../screens/about_us_screen.dart';
import '../screens/main_screen.dart';

class Routes {
  static List<GetPage> get page => [
        GetPage(name: '/main', page: () => MainScreen()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/myads', page: () => MyAdsScreen()),
        GetPage(name: '/mypayments', page: () => PaymentsScreen()),
        GetPage(
            name: '/bookmarkandnotes', page: () => const BookmarkAndNotes()),
        GetPage(name: '/recent', page: () => const RecentScreen()),
        GetPage(name: '/setting', page: () => SettingScreen()),
        GetPage(name: '/support', page: () => SupportScreen()),
        GetPage(name: '/rules', page: () => OurRulesScreen()),
        GetPage(name: '/questions', page: () => const QuestionScreen()),
        GetPage(name: '/aboutus', page: () => AboutUsScreen()),
        GetPage(name: '/chat', page: () => ChatScreen()),
        GetPage(name: '/citysearch', page: () => const CitySearchScreen()),
        GetPage(name: '/phonenumber', page: () => const SendCodeScreen()),
        GetPage(name: '/verifycode', page: () => ConfirmCodeScreen()),

        // GetPage(name: '/submitadd', page: () =>  SubmitAdsScreen()),
        //GetPage(name: '/showad', page: () => const ShowAdsScreen()),
        GetPage(name: '/managead', page: () => const ManageAdsScreen()),
        GetPage(name: '/plans', page: () => const PlansScreen()),
        GetPage(
            name: '/notification', page: () => const ChatNotificationScreen()),
      ];
}
