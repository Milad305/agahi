// ignore_for_file: avoid_print

import 'dart:core';

import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/models/StateModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';
import '../widget/MySncakBar.dart';

class CitySearchController extends GetxController {
  TextEditingController textFieldSearchCity = TextEditingController();
  var listStates = <StateModel>[].obs;
  var listCities = <CityModel>[].obs;
  var listAllCities = <CityModel>[].obs;
  var listSelectedCities = <CityModel>[].obs;
  var listTmpSearch = <CityModel>[].obs;
  var isShowClearButtonCity = false.obs;
  var isLoadingStates = false.obs;
  var isLoadingCities = false.obs;
  var isLoadingAllCities = false.obs;
  var showCities = false.obs;
  var isSearchMode = false.obs;
  RxInt selectedcat = (-1).obs;
  void getStates() {
    isLoadingStates(true);
    listStates.clear();
    var tmp = [];
    ApiProvider().getStates().then((res) {
      print(res.statusText);
      print(res.body);
      if (res.body != null) {
        getAllCities();
        tmp = res.body;
        for (var element in tmp) {
          listStates.add(StateModel.fromJson(element));
        }

        isLoadingStates(false);
      } else {
        print('State Controller Error');
      }
    });
  }

  void getCities({int? stateId}) {
    isLoadingCities(true);
    listCities.clear();
    var tmp = [];
    ApiProvider().getCity(stateId: stateId).then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listCities.add(CityModel.fromJson(element));
        }

        isLoadingCities(false);
      } else {
        print('City Controller Error');
      }
    });
  }

  void getAllCities() {
    isLoadingAllCities(true);
    listAllCities.clear();
    List<String> hinttmp = [];
    var tmp = [];
    ApiProvider().getCity().then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listAllCities.add(CityModel.fromJson(element));
          hinttmp.add(CityModel.fromJson(element).name ?? '');
        }
        isLoadingAllCities(false);
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
}
