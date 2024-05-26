import 'package:agahi_app/models/AdsModel.dart';

class NoteModel {
  int? id;
  AdsModel? ads;
  String? description;

  NoteModel({this.id, this.ads, this.description});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ads = json['ads'] != null ? new AdsModel.fromJson(json['ads']) : null;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    data['description'] = this.description;
    return data;
  }
}
