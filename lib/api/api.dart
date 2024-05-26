// ignore_for_file: avoid_print, non_constant_identifier_names
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ApiProvider extends GetConnect {
  String base_url = "http://chasbnak.com:8012/api/v1/";
  String domain = "http://chasbnak.com:8012";
  //String base_url = "http://192.168.251.4:8012/api/v1/";
  //String domain = "http://192.168.251.4:8012";
  @override
  int maxAuthRetries = 10;
  @override
  int maxRedirects = 10;
  Map<String, String> header = {
    'Authorization': 'Token ${GetStorage('agahi').read('token')}'
  };
  Map<String, String> headerWebSocket = {
    'token': '${GetStorage('agahi').read('token')}'
  };

  void error_message(String message) {
    Get.snackbar('خطا', message,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: double.infinity - 30,
        titleText: const Text(
          "خطا",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }

  void success_message(String message) {
    Get.snackbar('موفق', message,
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: double.infinity - 30,
        titleText: const Text(
          "موفق",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }

  Future<Response> deleteMessage(id) async {
    String url = '${base_url}chat/delete_unseen_message/';
    try {
      Response res = await post(
        url,
        {"message_id": id},
        headers: header,
      );
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return Future.error("error");
    }
  }

  Future<Response> checkVersion(String verison) async {
    String url = '${base_url}check-app-version/$verison';
    try {
      Response res = await get(url);
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return Future.error("error");
    }
  }

  Future<Response> addLike(int id) async {
    String url = '${base_url}ads/$id/add_like/';
    try {
      Response res = await get(url);
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return Future.error("error");
    }
  }

  Future<Response> getStaticPage(int id) async {
    String url = '${base_url}static_pages/$id';
    try {
      Response res = await get(url);
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return Future.error("error");
    }
  }

  Future<Response> addDislike(int id) async {
    String url = '${base_url}ads/$id/add_dislike/';
    try {
      Response res = await get(url);
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return Future.error("error");
    }
  }

  void dialogMyAds(String message) {
    Get.defaultDialog(
        contentPadding: EdgeInsets.all(20),
        radius: 5,
        title: 'جزییات درخواست',
        titleStyle: TextStyle(color: Colors.green),
        content: Column(
          children: [
            Text(textDirection: TextDirection.rtl, message),
          ],
        ),
        confirm: TextButton(onPressed: () => Get.back(), child: Text('باشه')));
  }

  Future<Response> getStates() async {
    String url = '${base_url}states';
    try {
      Response res = await get(url);
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return Future.error("error");
    }
  }

  Future<Response> paidCategory(
      {required String plansId, required id, adsId}) async{
    String url = '${base_url}payments/buy';
    Response res = await post(
        url,
        {
          'plans': plansId,
          'ads': id,
        },
        headers: header);
    if (res.isOk) {
      return res;
    } else {
      print(res);
      return res;
    }
      }

  Future<Response> buyPlan(
      {required String plansId, required id, adsId}) async {
    String url = '${base_url}payments/buy';
    Response res = await post(
        url,
        {
          'plans': plansId,
          'ads': id,
        },
        headers: header);
    if (res.isOk) {
      return res;
    } else {
      print(res);
      return res;
    }
  }

  Future<Response> getCity({int? stateId}) async {
    String? filter = stateId == null ? '' : '?state=$stateId';

    Response res = await get('${base_url}cities$filter');
    if (res.isOk) {
      return res;
    } else {
      return Future.error(res.statusCode.toString());
    }
  }

/*
try {} catch (e) {
       return Response(body: e,statusCode: 500);
      }
      */
  Future<Response> getAds(String search, int page) async {
    try {
      if (GetStorage('agahi').hasData('token')) {
        Response res = await get('${base_url}ads?search=$search&page=$page');
        if (res.isOk) {
          return res;
        } else {
          return Future.error(res.statusCode.toString());
        }
      } else {
        Response res = await get('${base_url}ads?search=$search&page=$page');
        if (res.isOk) {
          return res;
        } else {
          return Future.error(res.statusCode.toString());
        }
      }
    } catch (e) {
      return Response(body: e, statusCode: 500);
    }
  }

  Future<Response> getAdsByOwnerId({required int ownerId}) async {
    try {
      Response res =
          await get('${base_url}ads?owner__id=$ownerId', headers: header);
      print(res.body);
      print(res.statusText);
      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      return Response(body: e, statusCode: 500);
    }
  }

  Future<Response> getAdsById(adsId) async {
    try {
      Response res = await get('${base_url}ads/$adsId');

      if (res.isOk) {
        return res;
      } else {
        return Future.error(res.statusCode.toString());
      }
    } catch (e) {
      return Response(body: e, statusCode: 500);
    }
  }

  Future<Response> sendcode(String phoneNumber) async {
    Map mp = {'phone_number': phoneNumber};
    try {
      Response res = await post('${base_url}send-code', mp);
      print(res.statusCode);
      print(res.statusText);
      return res;
    } catch (e) {
      return Response(body: e, statusCode: 500);
    }
  }

  Future<Response> checkcode(String phoneNumber, String checkCode) async {
    Map mp = {'phone_number': phoneNumber, 'code': checkCode};
    Response res = await post('${base_url}check-code', mp);
    return res;
  }

  Future<Response> bookmarkAds(int adsId) async {
    Map mp = {'ads_id': adsId};
    Response res = await post('${base_url}bookmarks', mp, headers: header);
    return res;
  }

  Future<Response> checkBookmarkAds(int adsId) async {
    Response res = await post('${base_url}bookmarks/check', {'ads_id': adsId},
        headers: header);
    return res;
  }

  Future<Response> addNote(int adsId, String description) async {
    Response res = await post(
        '${base_url}notes', {'ads_id': adsId, 'description': description},
        headers: header);
    return res;
  }

  Future<Response> addView(int adsId) async {
    Response res = await get('${base_url}ads/$adsId/add_view', headers: header);
    return res;
  }

  Future<Response> getNotes() async {
    Response res = await get('${base_url}notes', headers: header);
    return res;
  }

  Future<Response> reportChat({
    required int chatRoomId,
    required String message,
  }) async {
    Map mp = {'room_id': chatRoomId, 'message': message};
    Response res = await post('${base_url}chat/report', mp, headers: header);
    return res;
  }

  Future<Response> blockChat({
    required int chatRoomId,
  }) async {
    Map mp = {'room_id': chatRoomId};
    Response res = await post('${base_url}chat/block', mp, headers: header);
    return res;
  }

  Future<Response> getRecentViews() async {
    Response res = await get('${base_url}ads/view', headers: header);
    return res;
  }

  Future<Response> getBookmars() async {
    Response res = await get('${base_url}bookmarks', headers: header);
    return res;
  }

  Future<Response> getCategory({int? categoryid}) async {
    String? child = categoryid == null ? '' : '/childs/$categoryid';
    Response res = await get('${base_url}categories$child');
    return res;
  }

  Future<Response> getMyAds() async {
    Response res = await get('${base_url}my-ads', headers: header);
    return res;
  }

  Future<Response> getMyAdsFilterByCategory(int? id) async {
    var a = Get.find<MainController>().get_cities_from_storage();
    String filters = '';
    a.forEach((element) {
      filters = '$filters${element.id},';
    });
    Response res = await get('${base_url}ads?cities=$filters&category=$id');

    return res;
  }

  Future<Response> deleteNote(int id) async {
    Response res = await delete('${base_url}note/$id', headers: header);
    return res;
  }

  Future<Response> deleteAd(int adsid) async {
    Response res = await delete('${base_url}ads/$adsid', headers: header);
    return res;
  }

  Future<Response> deleteNotesHistory(int action) async {
    Map mp = {
      0: 'delete_notes',
      1: 'delete_bookmark',
      2: 'delete_views',
    };
    Response res = await post('${base_url}clear-cache?', {'action': mp[action]},
        headers: header);
    return res;
  }

  Future<Response> updateProfile({
    CityModel? cityId,
    required bool showBlock,
    required bool showNotificationInChat,
    String? first_name,
    String? last_name,
  }) async {
    Map mp = {};
    if (first_name == "" && last_name == '') {
      mp = {
        //   'city': cityId!.toJson(),
        'show_block_chats': showBlock ? 'True' : 'False',
        'show_notification_in_chat': showNotificationInChat ? 'True' : 'False',
      };
    } else {
      mp = {
        // 'city': cityId!.toJson(),
        'show_block_chats': showBlock ? 'True' : 'False',
        'show_notification_in_chat': showNotificationInChat ? 'True' : 'False',
        'first_name': first_name,
        'last_name': last_name,
      };
    }
    Response res = await put('${base_url}profile', mp, headers: header);
    return res;
  }

  Future<Response> getRooms() async {
    Response res = await get('${base_url}chat/rooms', headers: header);
    return res;
  }

  Future<Response> getPlans() async {
    Response res = await get('${base_url}payments/plans');
    return res;
  }

  Future<Response> getChats(int id) async {
    Response res =
        await get('${base_url}chat/room/$id/messages', headers: header);
    return res;
  }

  Future<Response> getChatSuggestion(int id) async {
    Response res =
        await get('${base_url}category/$id/suggestions', headers: header);
    return res;
  }

  Future<Response> getCityFilter(String filter) async {
    var maincontroller = Get.find<MainController>();
    Response res;
    if (maincontroller.isLoggedIn.value) {
      res = await get('${base_url}ads?cities=$filter', headers: header);
    } else {
      res = await get('${base_url}ads?cities=$filter');
    }
    return res;
  }

  Future<Response> submitAds(
      {
      bool? exchanable,
      bool? isFixedPrice,  
      String? title,
      String? description,
      int? price,
      int? category_id,
      int? city,
      int? contact,
      List<MultipartFile>? images,
      double? lat,
      double? lng,
      List? fields,
      int? district}) async {
    //round to 2 float digits lat and lng
    if (lat != null && lng != null) {
      lat = double.parse(lat.toStringAsFixed(13));
      lng = double.parse(lng.toStringAsFixed(13));
    }
    FormData _formData = FormData({
      'images': images,
      'title': title,
      'city': city,
      'description': description,
      'price': price,
      'category_id': category_id,
      'contact': contact,
      'fields': fields,
      'district': district,
      'longitude': lng,
      'latitude': lat
    });

    Response res = await post('${base_url}ads', _formData, headers: header);
    return res;
  }

  Future<Response> saveEditAds(
      {int? id,
      String? title,
      String? description,
      int? price,
      int? category_id,
      int? city,
      int? contact,
      List<MultipartFile>? images,
      double? lat,
      double? lng,
      List? fields,
      int? district}) async {
    FormData _formData = FormData({
      'images': images,
      'title': title,
      'city': city,
      'description': description,
      'price': price,
      'category_id': category_id,
      'contact': contact,
      // 'fields': fields,
      'district': district,
      'longitude': lng,
      'latitude': lat
    });

    Response res = await put('${base_url}ads/$id', _formData, headers: header);
    return res;
  }

  Future<Response> submitSupportTicket(
      {String? title,
      String? description,
      String? category,
      String? periority,
      List<MultipartFile>? attachments}) async {
    FormData _formData = FormData({
      'attachments': attachments,
      'title': title,
      'description': description,
      'periority': periority,
      'category': category,
    });

    Response res = await post('${base_url}support', _formData, headers: header);
    return res;
  }

  Future<Response> getSetting() async {
    Response res = GetStorage('agahi').read('token') != null
        ? await get('${base_url}settings', headers: header)
        : await get('${base_url}settings');
    return res;
  }

  Future<Response> getTransactions() async {
    Response res =
        await get('${base_url}payments/transactions', headers: header);
    return res;
  }

  Future<Response> getDistricts() async {
    Response res = await get('${base_url}districts');
    return res;
  }

  Future<Response> getQuestions() async {
    Response res = await get('${base_url}questions');
    return res;
  }

  Future<Response> getNotifications() async {
    Response res = await get('${base_url}notifications', headers: header);
    return res;
  }
}
