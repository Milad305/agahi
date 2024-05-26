class NotificationChatModel {
  int? id;
  String? body;
  String? createdAt;

  NotificationChatModel({this.id, this.body, this.createdAt});

  NotificationChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    return data;
  }
}
