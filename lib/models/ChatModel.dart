import 'package:agahi_app/controller/main_controller.dart';
import 'package:get/get.dart';

class ChatModel {
  int? id;
  int? sender;
  String? message;
  bool? isSeen;
  String? createdAt;

  ChatModel({this.id, this.sender, this.message, this.isSeen, this.createdAt});

  bool isSelf(){
    if(Get.find<MainController>().userId.value != sender ){
      return false;
    }
    else{
      return true;
    }
  }

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    message = json['message'];
    isSeen = json['is_seen'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['is_seen'] = this.isSeen;
    data['created_at'] = this.createdAt;
    return data;
  }
}
