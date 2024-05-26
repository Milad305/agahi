import 'package:agahi_app/utils/widget_generator.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

class CategoryFeature {
  int? id;
  String? name;
  String? key;
  int? type;
  List<dynamic>? additionalData;
  TextEditingController? textEditController = new TextEditingController();

  CategoryFeature(
      {this.id, this.name, this.key, this.type, this.additionalData});

  CategoryFeature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    key = json['key'];
    type = json['type'];
    additionalData = json['additional_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['key'] = this.key;
    data['type'] = this.type;
    data['additional_data'] = this.additionalData;
    return data;
  }

  Widget get_widget() {
    WidgetGenerator widgetGenerator = WidgetGenerator();
    return widgetGenerator.generate(this);
  }
}
