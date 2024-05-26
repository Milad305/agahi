import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/models/QuestionModel.dart';
import 'package:agahi_app/models/StateModel.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var listRecentViews = <AdsModel>[].obs;
  var isLoadingRecentView = false.obs;
  var isLoadingQuestions = false.obs;
  var hasUpdate = false.obs;
  var refreshWidget = false.obs;
  var listCities = <CityModel>[].obs;
  var listStates = <StateModel>[].obs;
  var listQuestions = <QuestionsModel>[].obs;
  var isLoadingCitiesAndStates = false.obs;
  var isShowCity = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  CityModel? selectedCity;

  void getQuestions() {
    isLoadingQuestions(true);
    listQuestions.clear();
    ApiProvider().getQuestions().then((res) {
      List tmp = res.body['data'];
      for (var element in tmp) {
        listQuestions.add(QuestionsModel.fromJson(element));
      }
      isLoadingQuestions(false);
    });
  }

  void getRecentView() {
    isLoadingRecentView(true);
    listRecentViews.clear();
    ApiProvider().getRecentViews().then((res) {
      if (res.isOk) {
        List tmp = res.body['data'];
        for (var element in tmp) {
          listRecentViews.add(AdsModel.fromJson(element));
        }
        isLoadingRecentView(false);
      } else {
        MySnackBar(
            'خطا در دریافت اطلاعات',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void getDeleteAction(int action) {
    ApiProvider().deleteNotesHistory(action).then((res) {
      MySnackBar(
          res.body['data'] ?? '',
          CsuccessColor,
          Icon(
            Icons.check_circle,
            color: CsuccessColor,
          ));
    });
  }

  void getStates() {
    isLoadingCitiesAndStates(true);
    listStates.clear();
    var tmp = [];
    ApiProvider().getStates().then((res) {
      print(res.body);
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listStates.add(StateModel.fromJson(element));
        }

        isLoadingCitiesAndStates(false);
      } else {
        print('State Controller Error');
      }
    });
  }

  void getCities(int stateId) {
    isLoadingCitiesAndStates(true);
    listCities.clear();
    var tmp = [];
    ApiProvider().getCity(stateId: stateId).then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listCities.add(CityModel.fromJson(element));
        }

        isLoadingCitiesAndStates(false);
      } else {
        print('City Controller Error');
      }
    });
  }

  void updateProfile() {
    var maincontroller = Get.find<MainController>();

    ApiProvider().updateProfile(
        cityId: selectedCity,
        showBlock: maincontroller.showBlocedMessages.value,
        showNotificationInChat: maincontroller.showMessages.value,
        first_name: nameController.text,
        last_name: lastnameController.text);
  }
}
