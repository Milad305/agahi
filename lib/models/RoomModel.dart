import 'package:agahi_app/models/AdsModel.dart';

class RoomModel {
  int? id;
  AdsModel? ads;
  bool? isBlocked;
  bool? isActive;
  String? lastMessage;
  int? UnreadCount;
  String? createdAt;

  RoomModel(
      {this.id,
      this.ads,
      this.isBlocked,
      this.isActive,
      this.lastMessage,
      this.UnreadCount,
      this.createdAt});

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ads = json['ads'] != null ? new AdsModel.fromJson(json['ads']) : null;
    isBlocked = json['is_blocked'];
    isActive = json['is_active'];
    lastMessage = json['last_message'];
    UnreadCount = json['unread_count'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.ads != null) {
      data['ads'] = this.ads!.toJson();
    }
    data['is_blocked'] = this.isBlocked;
    data['is_active'] = this.isActive;
    data['last_message'] = this.lastMessage;
    data['unread_count'] = this.UnreadCount;
    data['created_at'] = this.createdAt;
    return data;
  }
}
