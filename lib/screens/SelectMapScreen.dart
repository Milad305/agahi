import 'package:agahi_app/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class SelectMapScreen extends StatelessWidget {
  final Function() refreshPage;
  SelectMapScreen({super.key, required this.refreshPage});

  @override
  Widget build(BuildContext context) {
    Get.find<LocationController>().isSelected(false);
    return WillPopScope(
      onWillPop: () async {
        Get.find<LocationController>().saveLocation();
        Get.find<LocationController>().isSelected(true);
        Get.find<LocationController>().isPickingLocation(false);
        refreshPage();

        return Future(() => false);
      },
      child: CustomScaffold(
        body: SafeArea(
          child: FullLocationPicker(),
        ),
      ),
    );
  }
}
