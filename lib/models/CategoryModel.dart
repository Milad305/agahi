import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import 'CategoryFeature.dart';

class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? icon;
  String? darkmodeIcon;
  int? plan;
  int? childsCount;
  double? fee;
  List<CategoryFeature>? features;

  CategoryModel(
      {this.id,
      this.name,
      this.description,
      this.icon,
      this.darkmodeIcon,
      this.childsCount,
      this.plan,
      this.fee,
      this.features});

  Widget? getIcon() {
    bool isdark = Get.isDarkMode;
    if (icon == null && darkmodeIcon == null) {
      return null;
    } else {
      if (isdark) {
        if (darkmodeIcon != null) {
          return Image.network('${ApiProvider().domain}$darkmodeIcon');
        } else {
          return Image.network('${ApiProvider().domain}$icon');
        }
      } else {
        return Image.network('${ApiProvider().domain}$icon');
      }
    }
  }

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    darkmodeIcon = json['darkmode_icon'];
    childsCount = json['childs_count'];
    fee = double.parse(json['fee'].toString());
    plan = json['plan'];
    if (json['features'] != null) {
      features = <CategoryFeature>[];
      json['features'].forEach((v) {
        features!.add(new CategoryFeature.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['darkmode_icon'] = this.darkmodeIcon;
    data['childs_count'] = this.childsCount;
    data['plan'] = this.plan;

    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
