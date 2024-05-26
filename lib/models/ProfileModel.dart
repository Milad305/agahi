import 'package:agahi_app/models/CityModel.dart';

class Profile {
  int? id;
  User? user;
  CityModel? city;
  String? nationalCode;
  bool? showBlockChats;
  bool? showNotificationInChat;

  Profile(
      {this.id,
        this.user,
        this.city,
        this.nationalCode,
        this.showBlockChats,
        this.showNotificationInChat});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    city = json['city'] != null ? new CityModel.fromJson(json['city']) : null;
    nationalCode = json['national_code'];
    showBlockChats = json['show_block_chats'];
    showNotificationInChat = json['show_notification_in_chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['national_code'] = this.nationalCode;
    data['show_block_chats'] = this.showBlockChats;
    data['show_notification_in_chat'] = this.showNotificationInChat;
    return data;
  }
}

class User {
  int? id;
  String? username;

  User({this.id, this.username});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    return data;
  }
}