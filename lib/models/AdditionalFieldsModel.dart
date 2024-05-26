class AdditionalFields {
  String? label;
  String? value;
  String? key;
  int? type;

  AdditionalFields({this.label, this.value, this.key, this.type});

  AdditionalFields.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    key = json['key'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['key'] = this.key;
    data['type'] = this.type;
    return data;
  }
}