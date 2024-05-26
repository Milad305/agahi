import 'package:agahi_app/models/AdsModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../constant/colors.dart';
import 'PlanModel.dart';

class TransactionModel {
  int? id;
  List<PlanModel>? plans;
  AdsModel? ads;
  int? price;
  int? status;
  int? trackingCode;
  String? description;
  String? createdAt;

  TransactionModel(
      {this.id,
      this.plans,
      this.ads,
      this.price,
      this.status,
      this.trackingCode,
      this.description,
      this.createdAt});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['plans'] != null) {
      plans = <PlanModel>[];
      json['plans'].forEach((v) {
        plans!.add(new PlanModel.fromJson(v));
      });
    }
    ads = json['ads'] != null ? new AdsModel.fromJson(json['ads']) : null;
    price = json['price'];
    status = json['status'];
    trackingCode = json['tracking_code'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    data['price'] = this.price;
    data['status'] = this.status;
    data['tracking_code'] = this.trackingCode;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    return data;
  }

  DateTime getcreatedAt() {
    return DateTime.parse(this.createdAt!);
  }

  DateTime get_created_at() {
    var x = DateTime.parse(this.createdAt!);
    var data = x.add(const Duration(hours: 3, minutes: 30));

    return data;
  }

  Jalali getjCreatedAt() {
    var x = getcreatedAt();

    print(x);
    return getcreatedAt().toJalali();
  }

  Icon get_icon() {
    switch (this.status) {
      case 0:
        return Icon(
          Icons.error,
          color: CwarningColor,
          size: 21,
        );
        break;
      case 1:
        return Icon(
          Icons.library_add_check,
          color: CsuccessColor,
          size: 21,
        );
      case 2:
        return Icon(
          Icons.cancel,
          color: CerrorColor,
          size: 21,
        );
    }
    return Icon(
      Icons.hourglass_empty,
      color: CerrorColor,
      size: 21,
    );
  }
}
