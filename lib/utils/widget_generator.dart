// ignore_for_file: avoid_print, invalid_use_of_protected_member

import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/models/CategoryFeature.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widget/widget.dart';
import 'package:get/get.dart';

class WidgetGenerator {
  Widget generate(CategoryFeature field) {
    Widget fieldtype = Container();
    switch (field.type) {
      case 0:
        // Return TextField
        fieldtype = Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SubmitTextFieldWidget(
              onChange: ((p0) {
                Get.find<AddAdsController>().saveData();
              }),
              height: 40,
              controller: field.textEditController,
              hint: '${field.name} وارد نمایید',
              title: field.name),
        );
        break;
      case 1:
        // Return NumberField

        fieldtype = SubmitTextFieldWidget(
            onChange: ((p0) {
              Get.find<AddAdsController>().saveData();
            }),
            height: 40,
            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
            inputType: TextInputType.number,
            controller: field.textEditController,
            hint: '${field.name} وارد نمایید',
            title: field.name);
        break;
      case 2:
        {
          var featureKey = field.key;
          List itm = [];
          for (int i = 0; i < field.additionalData!.length; i++) {
            itm.add(field.additionalData![i]["title"]);
          }
          Get.find<AddAdsController>().items[featureKey] = itm;
          var featureTitle = field.additionalData![0][
              'title']; // You might need to adjust this based on your actual data structure
          /*     Get.find<AddAdsController>().selectedValues[featureKey!] =
              featureTitle; */

          //print(":::::::::::${y.first}");

          //  return Container();
          return Row(
            children: [
              Text(featureKey.toString()),
              const SizedBox(
                width: 40,
              ),
              Expanded(
                child: GetBuilder<AddAdsController>(builder: (controller) {
                  !controller.items.value.values.first.contains("انتخاب کنید")
                      ? controller.items.value[featureKey].add("انتخاب کنید")
                      : print("nooooooooooooooooooooooooooooooo");
                  return DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedValues.isNotEmpty
                        ? controller.selectedValues[featureKey]
                        : "انتخاب کنید",
                    items: controller.items.value[featureKey]!
                        .map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      controller.selectedValues.value[featureKey] = newValue!;
                      print(controller.selectedValues.value[featureKey]);

                      Get.find<AddAdsController>().saveData();

                      controller.update();
                    },
                  );
                }),
              ),
            ],
          );
        }
    }
    return fieldtype;
  }
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          this.itemCount, (index) => this.itemBuilder(context, index)).toList(),
    );
  }
}
