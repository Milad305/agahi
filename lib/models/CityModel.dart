import 'package:agahi_app/models/DistrictModel.dart';
import 'package:agahi_app/models/StateModel.dart';

class CityModel {
  int? id;
  String? name;
  StateModel? state;
  List<DistrictModel>? districts;

  CityModel({this.id, this.name, this.state, this.districts});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state =
        json['state'] != null ? new StateModel.fromJson(json['state']) : null;
    if (json['districts'] != null) {
      districts = <DistrictModel>[];
      json['districts'].forEach((v) {
        districts!.add(new DistrictModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.districts != null) {
      data['districts'] = this.districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  Map<String, dynamic> todraftJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.districts != null) {
      data['districts'] = this.districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
