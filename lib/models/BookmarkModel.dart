import 'package:agahi_app/models/AdsModel.dart';

class BookmarkModel {
  int? id;
  AdsModel? ads;

  BookmarkModel({this.id, this.ads});

  BookmarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ads = json['ads'] != null ? new AdsModel.fromJson(json['ads']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    return data;
  }
}
