import 'package:agahi_app/models/AdditionalFieldsModel.dart';
import 'package:agahi_app/models/CategoryModel.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/models/DistrictModel.dart';
import 'package:agahi_app/models/ImageModel.dart';
import 'package:agahi_app/models/OwnerModel.dart';
import '../api/api.dart';

class AdsModel {
  int? id;
  OwnerModel? owner;
  String? title;
  int? chatId;
  String? description;
  CategoryModel? category;
  int? price;
  int? status;
  String? rejectReason;
  List<AdditionalFields>? additionalFields;
  int? contact;
  List<ImageModel>? images;
  String? createdAt;
  CityModel? city;
  DistrictModel? district;
  bool? isForce;
  double? lat;
  double? lang;
  int? view_count;
  int? likes;
  int? deslikes;
  bool? ladder;
  String? link;
  String? ladder_time;

  AdsModel({
    this.id,
    this.owner,
    this.title,
    this.ladder,
    this.chatId,
    this.description,
    this.ladder_time,
    this.category,
    this.view_count,
    this.link,
    this.likes,
    this.deslikes,
    this.price,
    this.status,
    this.rejectReason,
    this.additionalFields,
    this.contact,
    this.lat,
    this.lang,
    this.images,
    this.city,
    this.createdAt,
    this.isForce,
  });

  String? getprice() {
    String? exp = '';
    switch (price) {
      case -1:
        {
          exp = 'توافقی';
          return exp;
        }
      case 0:
        {
          exp = 'رایگان';
          return exp;
        }
      default:
        {
          exp = '$price تومان';
          return exp;
        }
    }
  }

  String? getPreviewImage() {
    if (images?.length == 0) {
      return null;
    } else {
      return '${ApiProvider().domain}${images![0].image}';
    }
  }

  String getCityName() {
    String cityname = '';
    if (district == null) {
      cityname = city!.name!;
    } else {
      cityname = '${city!.name!} (${district!.name})';
    }
    return cityname;
  }

  AdsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'] != null ? OwnerModel.fromJson(json['owner']) : null;
    title = json['title'];
    link = json['link'];
    chatId = json['chat_id'];
    description = json['description'];
    view_count = json['view_count'];
    likes = json['likes'];
    deslikes = json['dislikes'];
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    city = json['city'] != null ? CityModel.fromJson(json['city']) : null;
    district = json['district'] != null
        ? DistrictModel.fromJson(json['district'])
        : null;
    lat = json['latitude'];
    lang = json['longitude'];
    price = json['price'];
    status = json['status'];
    ladder = json['ladder'];
    rejectReason = json['reject_reason'];
    if (json['additional_fields'] != null) {
      additionalFields = <AdditionalFields>[];
      json['additional_fields'].forEach((v) {
        additionalFields!.add(AdditionalFields.fromJson(v));
      });
    }
    contact = json['contact'];
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    isForce = json['sale'];
    ladder_time = json['ladder_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['title'] = title;
    data['chat_id'] = chatId;
    data['description'] = description;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (district != null) {
      data['district'] = district!.toJson();
    }
    data['price'] = price;
    data['status'] = status;
    data['reject_reason'] = rejectReason;
    if (additionalFields != null) {
      data['additional_fields'] =
          additionalFields!.map((v) => v.toJson()).toList();
    }
    data['contact'] = contact;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['is_force'] = isForce;
    return data;
  }
}
