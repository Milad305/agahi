class Setting {
  String? privacy;
  String? aboutUs;
  String? rulls;
  String? terms;
  int? minAppCode;

  Setting({this.privacy, this.aboutUs, this.minAppCode});

  Setting.fromJson(Map<String, dynamic> json) {
    privacy = json['privacy'];
    aboutUs = json['about'];
    minAppCode = json['min_app_code'];
    rulls = json['conditions'];
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['privacy'] = this.privacy;
    data['about_us'] = this.aboutUs;
    data['min_app_code'] = this.minAppCode;
    return data;
  }
}
