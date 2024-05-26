// ignore_for_file: curly_braces_in_flow_control_structures, invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/chat_controller.dart';
import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/setting_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/models/CategoryModel.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/models/ProfileModel.dart';
import 'package:agahi_app/models/SettingModel.dart';
import 'package:agahi_app/screens/show_ads_screen.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';

import '../models/StateModel.dart';
import '../models/categorymodel_router_model.dart';
import '../screens/update_screen.dart';

class MainController extends GetxController {
  TextEditingController textFieldSearchAds = TextEditingController();
  TextEditingController textFieldSearchCity = TextEditingController();
  TextEditingController textFieldPhoneNumber = TextEditingController();
  TextEditingController textFieldCheckCode = TextEditingController();
  TextEditingController textFieldDialogNote = TextEditingController();
  Rx<ValueNotifier<bool>> isNetworkDisabled = ValueNotifier(false).obs;
  var deeplinking = false.obs;
  var currentCat = 1.obs;
  RxList searchList = [].obs;
  var refreshWidget = false.obs;
  var isAppLoaded = false.obs;
  var bottomindex = 0.obs;
  var uniloaded = false.obs;
  var isImageFiltered = false.obs;
  var currentPositionPic = 0.obs;
  var totalDots = 1.obs;
  var isShowClearButtonAds = false.obs;
  var isShowClearButtonCity = false.obs;
  var showDeactiveChat = false.obs;
  var showMessages = false.obs;
  var showBlocedMessages = false.obs;
  var selectedPriority = ''.obs;
  var selectedCategorySupport = ''.obs;
  var listAds = <AdsModel>[].obs;
  var listMyAds = <AdsModel>[].obs;
  var listCategory = <CategoryModel>[].obs;
  var listCategoryChild = <CategoryModel>[].obs;
  var listCategoryRoute = <CategoryModelRouter>[].obs;
  var selectedCategoryRoute = CategoryModelRouter().obs;
  var needUpdte = false.obs;
  var isLoadingAds = false.obs;
  var isLoggedIn = false.obs;
  var isSendingCode = false.obs;
  var isVerifingCode = false.obs;
  var isLoadingCategory = false.obs;
  var isLoadingCategoryChild = false.obs;
  var isLoadingMyAds = false.obs;
  var isLoadingSubmitNote = false.obs;
  var isLoadingBookmark = false.obs;
  var isBookmarked = false.obs;
  var isShowChild = false.obs;
  var submit_ticket_loading = false.obs;
  var phoneNumber = ''.obs;
  var userId = 0.obs;
  var searchText = ''.obs;
  var searchHistory = [].obs;

  var adsModel = AdsModel().obs;
  var listOwenerAds = <AdsModel>[].obs;
  RxBool isinternet = true.obs;
  var setting = Setting().obs;
  var profile = Profile().obs;
  var current_ads_page = 1.obs;
  var isLoadingCitiesAndStatesFirst = false.obs;
  var listCitiesFirst = <CityModel>[].obs;
  var listStatesFirst = <StateModel>[].obs;
  var attachments = <File>[].obs;
  var isShowCityFirst = false.obs;
  var isLoadingOwnerAds = false.obs;
  var hasFilter = false.obs;
  var catListAds = <AdsModel>[].obs;
  var searchAds = <AdsModel>[].obs;
  var filteredcatListAds = <AdsModel>[].obs;
  var isImageFilter = false.obs;
  TextEditingController fromPriceController = TextEditingController();
  TextEditingController toPriceController = TextEditingController();
  var fromPriceFilter = (-1).obs;
  var toPriceFilter = 99999999999999999.obs;
  RxInt time = 60.obs;
  Timer? _timer;
  RxBool resendVisible = false.obs;
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  final RxInt userReaction =
      RxInt(-1); // 1 for thumbs-up, 0 for thumbs-down, -1 for no reaction
  Map _source = {ConnectivityResult.none: false};
  bool canSetReaction() {
    // Allow setting a reaction only if the user hasn't reacted yet
    return userReaction.value == -1;
  }

  void timer(start) {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          time(start);
          resendVisible.value = true;
        } else {
          start--;
          time(start);
        }
        update();
      },
    );
  }

  getStaticPage(int id) async {
    await ApiProvider().getStaticPage(id).then((value) {
      var json = jsonDecode(value.body);

      print(value);
    });
  }

  timerCancel() {
    if (_timer != null) _timer!.cancel();
  }

  void resendOTP() {
    // Implement your resend OTP logic here

    resendVisible.value = false;

    timer(60);
    sendCode();
  }

  void setReaction(int reaction, {required AdsModel ads}) {
    if (userReaction.value == reaction) {
      userReaction.value = -1; // Remove the reaction if already reacted
    } else {
      // Allow setting a reaction only if the user hasn't reacted yet
      reaction == 1
          ? {
              ApiProvider().addLike(ads.id!),
              ads.likes != null ? ads.likes = ads.likes! + 1 : ads.likes = 1
            }
          : {
              ApiProvider().addDislike(ads.id!),
              ads.deslikes != null
                  ? ads.deslikes = ads.deslikes! + 1
                  : ads.deslikes = 1
            };

      userReaction.value = reaction;
    }
    //TODO::send to server the reaction
    GetStorage().write('reaction_${ads.id}', userReaction.value);
    MySnackBar("امتیاز شما به این آگهی ثبت شد", Colors.green, Icon(Icons.done));
  }

  @override
  void onInit() {
    super.onInit();
    _networkConnectivity.initialise();
    checkVPNConnectionStatus();
    _networkConnectivity.myStream.listen((source) {
      _source = source;

      String value = _source.keys.toList()[0].toString();

      if (value.toString() == "ConnectivityResult.none") {
        print(value);
        isinternet(false);
      } /*else if (what.value.toString() == "ConnectivityResult.vpn") {
        print("?????????????????vpn??????????????");
        isinternet(false);
        Get.to(NoInternet());
      }*/
      else
        isinternet(true);

      if (isinternet.value && Get.currentRoute == "/NoInternet") {
        Get.back();
      }

      print(
          "////////////////////////////////////////////////////////////////$isinternet");
    });
    timerCancel();
  }

  filterCatAds() {
    filteredcatListAds.value = catListAds.value;
    if (hasFilter.value) {
      filteredcatListAds.value = filteredcatListAds.value
          .where((element) =>
              fromPriceFilter.value <= element.price! &&
              toPriceFilter.value >= element.price!)
          .toList();
    }

    if (isImageFilter.value) {
      filteredcatListAds.value = filteredcatListAds.value
          .where((p0) => p0.images != null && p0.images!.isNotEmpty)
          .toList();
    }
  }

  void getAdsByOwner() {
    listOwenerAds.clear();
    isLoadingOwnerAds(true);
    ApiProvider()
        .getAdsByOwnerId(ownerId: adsModel.value.owner!.id!)
        .then((res) {
      List tmp = res.body['results'];
      for (var e in tmp) {
        listOwenerAds.add(AdsModel.fromJson(e));
      }
      isLoadingOwnerAds(false);
    });
  }

  /*  void checkVersion() async {
//  PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // Replace "your_api_endpoint" with the actual endpoint where you check for the latest version
    // String latestVersion = await fetchLatestVersion("your_api_endpoint");

    // if (latestVersion.compareTo(packageInfo.version) > 0) {
    // isNewVersionAvailable.value = true;
    showUpdateDialog();
    //}
  } */

  void getStatesFirst() {
    //listStatesFirst.clear();
    isLoadingCitiesAndStatesFirst(true);

    var tmp = [];
    ApiProvider().getStates().then((res) {
      print(res.body);
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listStatesFirst.add(StateModel.fromJson(element));
        }

        isLoadingCitiesAndStatesFirst(false);
      } else {
        print('State Controller Error');
      }
    });
  }

  void getCities(int stateId) {
    isLoadingCitiesAndStatesFirst(true);
    listCitiesFirst.clear();
    var tmp = [];
    ApiProvider().getCity(stateId: stateId).then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listCitiesFirst.add(CityModel.fromJson(element));
        }

        isLoadingCitiesAndStatesFirst(false);
      } else {
        print('City Controller Error');
      }
    });
  }

  void getCitiesFirst(int stateId) {
    isLoadingCitiesAndStatesFirst(true);
    listCitiesFirst.clear();
    var tmp = [];
    ApiProvider().getCity(stateId: stateId).then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listCitiesFirst.add(CityModel.fromJson(element));
        }

        isLoadingCitiesAndStatesFirst(false);
      } else {
        print('City Controller Error');
      }
    });
  }

  List<CityModel> get_cities_from_storage() {
    var a = <CityModel>[];
    var filtercity = GetStorage('agahi').read('filter');
    if (filtercity != null) {
      (filtercity as List).forEach((element) {
        if (element.runtimeType != CityModel) {
          a.add(CityModel.fromJson(element));
        } else {
          a.add(element);
        }
      });
    }
    return a;
  }

  void addCategoryRoute({required CategoryModel cat, required bool isMain}) {
    selectedCategoryRoute(
        CategoryModelRouter(id: cat.id, isMainCategory: isMain));
    listCategoryRoute.add(selectedCategoryRoute.value);
  }

  void getBackCategory() {
    for (int i = 0; i < listCategoryRoute.length; i++) {
      if (selectedCategoryRoute.value.id == listCategoryRoute[i].id &&
          listCategoryRoute[i].isMainCategory == false) {
        selectedCategoryRoute(listCategoryRoute[i - 1]);
        getCategoryChild(selectedCategoryRoute.value.id!);
      } else if (selectedCategoryRoute.value.id == listCategoryRoute[i].id &&
          listCategoryRoute[i].isMainCategory == true) {
        isShowChild(false);
      }
    }
  }

  void getAds() {
    listAds.clear();
    isLoadingAds(true);
    bool isFilter = GetStorage('agahi').hasData('filter');
    if (isFilter == false) {
      ApiProvider()
          .getAds(textFieldSearchAds.text, current_ads_page.value)
          .then((res) {
        if (res.body != null) {
          List tmp = res.body["results"];
          for (var element in tmp) {
            listAds.add(AdsModel.fromJson(element));
          }
          isLoadingAds(false);
        } else {
          ApiProvider().error_message('خطا در دریافت اطلاعات');
        }
      });
    } else {
      var a = get_cities_from_storage();

      String filters = '';
      a.forEach((element) {
        filters = '$filters${element.id},';
      });
      print(filters);
      ApiProvider().getCityFilter(filters).then((res) {
        if (res.body != null) {
          List tmp = res.body["results"];
          for (var element in tmp) {
            listAds.add(AdsModel.fromJson(element));
          }
          isLoadingAds(false);
        } else {
          ApiProvider().error_message('خطا در دریافت اطلاعات');
        }
      });
    }
  }

  void checkBookmarkAds() async {
    isBookmarked(false);
    if (isLoggedIn.value) {
      isLoadingBookmark(true);
      ApiProvider().checkBookmarkAds(adsModel.value.id!).then((res) {
        if (res.body != null) {
          bool data = res.body['data'];
          isBookmarked(data);
          isLoadingBookmark(false);
        }
      });
    }
  }

  void addView(adsId) {
    var view = GetStorage('agahi').read('adView$adsId');
    if (view == null) {
      ApiProvider().addView(adsModel.value.id!).then((value) {
        if (value.isOk) {
          GetStorage('agahi').write('adView$adsId', 1);
        }
      });
    }
  }

  void bookmarkAds() async {
    if (isLoggedIn.value) {
      isBookmarked(!isBookmarked.value);
      isLoadingBookmark(true);
      ApiProvider().bookmarkAds(adsModel.value.id!).then((res) {
        if (res.isOk) {
          isLoadingBookmark(false);
          MySnackBar(
              res.body['data'],
              CsuccessColor,
              Icon(
                Icons.bookmark,
                color: CsuccessColor,
              ));
        }
      });
    } else {
      Get.toNamed('/phonenumber');
    }
  }

  getAdsById(id) async {
    await ApiProvider().getAdsById(id).then((res) {
      if (res.isOk) {
        adsModel.value = AdsModel.fromJson(res.body);
        Get.to(ShowAdsScreen(ads: adsModel.value));
        /*  deeplinking.value = true;
        isAppLoaded.value
            ? {deeplinking(false), Get.to(ShowAdsScreen(ads: adsModel.value))}
            : null; */
      } else {
        MySnackBar(
            res.statusText ?? 'آگهی یافت نشد',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void addNote() async {
    isLoadingSubmitNote(true);
    await ApiProvider()
        .addNote(adsModel.value.id!, textFieldDialogNote.text)
        .then((res) {
      if (res.isOk) {
        isLoadingSubmitNote(false);
        Get.back();

        MySnackBar(
            res.body['data'],
            CsuccessColor,
            Icon(
              Icons.description,
              color: CsuccessColor,
            ));
      }
    });
    textFieldDialogNote.text = '';
  }

  Future<bool> isUpdate() async {
    try {
      await ApiProvider().checkVersion("0").then((res) {
        if (res.isOk) {
          return res.body['status'] == 1 ? true : false;
        } else
          return false;
      });
    } catch (e) {
      return true;
    }
    return true;
  }

  void runsplash() async {
    Timer(Duration.zero, () async {
      if (GetStorage('agahi').read('isdarkmode') == true) {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        GetStorage('agahi').write('isdarkmode', false);
        Get.changeThemeMode(ThemeMode.light);
      }
      /* bool isupdate = await isUpdate();
      // isupdate ? null : Get.offAll(UpdataApp()); */
      if (GetStorage('agahi').hasData('token')) {
        print(GetStorage('agahi').read('token'));
        isLoggedIn(true);
        phoneNumber(GetStorage('agahi').read('phone'));
        userId(GetStorage('agahi').read('id'));
        Get.find<ChatController>().streamChannel();
      } else {
        isLoggedIn(false);
      }
    });
    // if (GetStorage('agahi').hasData('city')) {
    //   Timer(const Duration(seconds: 2), () {
    //     getSettings();
    //     getCategory();
    //     getAds();
    //     Get.offNamed('/main');
    //   });
    // } else {
    //   Timer(const Duration(seconds: 2), () {});
    // }
  }

  void sendCode() {
    if (textFieldPhoneNumber.text.length == 11) {
      isSendingCode(true);
      ApiProvider().sendcode(textFieldPhoneNumber.text).then((res) {
        if (res.isOk) {
          isSendingCode(false);
          MySnackBar(
              'کد با موفقیت به شماره ${textFieldPhoneNumber.text}ارسال شد',
              CsuccessColor,
              Icon(
                Icons.check_circle_rounded,
                color: CsuccessColor,
              ));
          Get.toNamed('/verifycode');
        } else {
          isSendingCode(false);
          MySnackBar(
              'خطا در ارسال اطلاعات',
              CerrorColor,
              Icon(
                Icons.error_rounded,
                color: CerrorColor,
              ));
        }
      });
    } else {
      MySnackBar(
          'لطفا شماره موبایل خود را وارد نمایید',
          CwarningColor,
          Icon(
            Icons.warning_rounded,
            color: CwarningColor,
          ));
    }
  }

  void checkCode() {
    isVerifingCode(true);
    if (textFieldCheckCode.text.length == 5) {
      ApiProvider()
          .checkcode(textFieldPhoneNumber.text, textFieldCheckCode.text)
          .then((res) {
        if (res.isOk) {
          isVerifingCode(false);
          GetStorage('agahi').write('token', res.body['data']['token']);
          GetStorage('agahi').write('phone', textFieldPhoneNumber.text);
          GetStorage('agahi').write('id', res.body['data']['id']);
          Get.find<ChatController>().streamChannel();
          Restart.restartApp();
        } else if (res.statusCode == 401) {
          isVerifingCode(false);
          MySnackBar(
              'کد وارد شده صحیح نمیباشد',
              CerrorColor,
              Icon(
                Icons.error_rounded,
                color: CerrorColor,
              ));
        }
      });
    } else {
      MySnackBar(
          'کد را وارد نمایید',
          CwarningColor,
          Icon(
            Icons.warning_rounded,
            color: CwarningColor,
          ));
    }
  }

  getCategory() {
    listCategory.clear();
    isLoadingCategory(true);
    listCategory.clear();
    ApiProvider().getCategory().then((res) {
      if (res.isOk) {
        isLoadingCategory(false);
        List lst = res.body['data'];
        for (var element in lst) {
          listCategory.add(CategoryModel.fromJson(element));
        }
        update();
      } else {
        MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void getCategoryChild(int id) {
    isLoadingCategoryChild(true);
    listCategoryChild.clear();
    ApiProvider().getCategory(categoryid: id).then((res) {
      if (res.isOk) {
        isLoadingCategory(false);
        List lst = res.body['data'];
        for (var element in lst) {
          listCategoryChild.add(CategoryModel.fromJson(element));
        }
      } else {
        MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  getMyAds() {
    isLoadingMyAds(true);

    ApiProvider().getMyAds().then((res) {
      if (res.isOk) {
        listMyAds.clear();

        List lst = res.body;
        for (var element in lst) {
          listMyAds.add(AdsModel.fromJson(element));
        }
        isLoadingMyAds(false);
      } else {
        MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void getMyAdsFitlerByCategory(int catid) {
    isLoadingAds(true);
    print(catid);
    ApiProvider().getMyAdsFilterByCategory(catid).then((res) {
      if (res.isOk) {
        catListAds.clear();
        List lst = res.body['results'];
        for (var element in lst) {
          catListAds.add(AdsModel.fromJson(element));
        }
        isLoadingAds(false);
      } else {
        MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void getMyAdsFitlerByCategorymain(int catid) {
    isLoadingAds(true);
    print(catid);

    ApiProvider().getMyAdsFilterByCategory(catid).then((res) {
      if (res.isOk) {
        listAds.clear();
        List lst = res.body['results'];
        for (var element in lst) {
          listAds.add(AdsModel.fromJson(element));
        }
        isLoadingAds(false);
      } else {
        MySnackBar(
            res.statusText ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  getSettings() {
    var citysearchcontroller = Get.find<CitySearchController>();

    ApiProvider().getSetting().then((value) {
      if (value.isOk) {
        setting(Setting.fromJson(value.body["data"]['setting']));
        if (value.body["data"]['setting']['min_app_code'] != 1000) {
          MySnackBar(
              "بروزرسانی جدید چسبناک منتشر شده است لطفا به روز رسانی کنید",
              Colors.green,
              Icon(
                Icons.system_update_tv_sharp,
                color: Colors.white,
              ));
        }
        if (value.body["data"]['profile'] != null) {
          profile(Profile.fromJson(value.body["data"]['profile']));
          GetStorage('agahi').write('profile', value.body["data"]['profile']);
          Get.find<SettingController>().nameController.text =
              value.body["data"]['profile']['first_name'];
          Get.find<SettingController>().lastnameController.text =
              value.body["data"]['profile']['last_name'];
          showBlocedMessages(profile.value.showBlockChats);
          showMessages(profile.value.showNotificationInChat);
        }
      }

      if (GetStorage('agahi').hasData('filter')) {
        citysearchcontroller.listSelectedCities(get_cities_from_storage());
      } else {
        if (profile.value.city != null) {
          citysearchcontroller.listSelectedCities.value = [profile.value.city!];
        } else {
          // citysearchcontroller.listSelectedCities.clear();
          //TODO:
          // citysearchcontroller.listSelectedCities = [
          //   CityModel(id: 2, name: 'تهران',state: StateModel(id: 2,))
          // ];
        }
      }

      Get.find<SettingController>().selectedCity = profile.value.city;
    });
  }

  adsSearch(String text) {
    searchAds.value = listAds.value
        .where((element) => element.title!.contains(text))
        .toList();

    if (searchHistory.value.contains({"title": text.toString()})) {
      //nothing
    } else {
      final data = GetStorage('agahi').read("searchHistory");
      data != null
          ? searchHistory.value = List<Map<String, dynamic>>.from(data)
          : null;
      searchHistory.value.add({"title": text.toString()});
      GetStorage('agahi').write("searchHistory", searchHistory.value);
      searchHistory.refresh();
    }
  }

  deleteHistory(String text) {
    searchHistory.value.removeWhere((element) => element["title"] == text);
    GetStorage('agahi').write("searchHistory", searchHistory.value);
    searchHistory.refresh();
  }

  readHistory() {
    final data = GetStorage('agahi').read("searchHistory");
    data != null
        ? searchHistory.value = List<Map<String, dynamic>>.from(data)
        : null;
  }

  void submitSupportTicket(
      {String? title,
      String? description,
      String? category,
      String? periority,
      List<MultipartFile>? attachments}) async {
    submit_ticket_loading(true);
    ApiProvider()
        .submitSupportTicket(
            title: title,
            description: description,
            category: category,
            periority: periority,
            attachments: attachments)
        .then(
      (value) {
        submit_ticket_loading(false);
        if (value.isOk) {
          MySnackBar(
              value.body["data"],
              CsuccessColor,
              Icon(
                Icons.check_circle,
                color: CsuccessColor,
              ));
          bottomindex(0);
          Get.offNamed("/main");
        }
      },
    ).onError(
      (error, stackTrace) {
        submit_ticket_loading(false);
      },
    );
  }

  void showUpdateDialog() {
    if (needUpdte.isTrue) {
      Get.defaultDialog(
        title: 'ورژن جدید',
        content: const Text('ورژن جدید چسبانک را دریافت کنید .'),
        textConfirm: 'بروزرسانی حالا',
        confirmTextColor: Colors.white,
        onConfirm: () {
          // Implement the logic to navigate to the app store for the update
          // For simplicity, we'll just close the dialog here
          Get.back();
        },
      );
    }
  }
}

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  // 1.
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      print("//////////////////////////" + result.toString());
      _checkStatus(result);
    });
  }

// 2.
  void _checkStatus(ConnectivityResult result) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      Get.find<MainController>().isinternet.value =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      Get.find<MainController>().isinternet.value = false;
    }
    _controller.sink.add({result: Get.find<MainController>().isinternet.value});
  }

  void disposeStream() => _controller.close();
}

void checkVPNConnectionStatus() async {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.vpn) {
      print('/////////////////////vpnnnnnnnnnnnn');
      /* Get.to(NoInternet(
        isVpn: true,
      ));*/
    } else {
      Get.back();
    }
  });
}
