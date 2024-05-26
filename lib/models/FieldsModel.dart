class FieldsModel {
  int? meter;

  FieldsModel({this.meter});

  FieldsModel.fromJson(Map<String, dynamic> json) {
    meter = json['meter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meter'] = this.meter;
    return data;
  }
}