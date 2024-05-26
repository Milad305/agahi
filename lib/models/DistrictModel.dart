import 'package:agahi_app/models/CityModel.dart';

class DistrictModel {
  int? id;
  String? name;
  CityModel? city;

  DistrictModel({this.id, this.name, this.city});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'] != null ? CityModel.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    return data;
  }
}
