import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

import '../constant/colors.dart';

class QuestionsModel {
  int? id;
  String? title;
  List<QuestionsModel>? childs;
  String? description;

  QuestionsModel({this.id, this.title, this.childs, this.description});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['childs'] != null) {
      childs = <QuestionsModel>[];
      json['childs'].forEach((v) {
        childs!.add(new QuestionsModel.fromJson(v));
      });
    }
    description = json['description'];
  }

  List<AccordionSection> child_Widgets() {
    var tmp = <AccordionSection>[];
    if (childs != null) {
      childs!.forEach((element) {
        tmp.add(AccordionSection(
            headerPadding: EdgeInsets.all(10),
            headerBackgroundColor: Cprimary,
            contentBorderColor: Cprimary,
            contentBorderRadius: 15,
            header: Text(
              element.title ?? 'بدون عنوان',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(element.description!)));
      });
    }
    return tmp;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.childs != null) {
      data['childs'] = this.childs!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    return data;
  }
}
