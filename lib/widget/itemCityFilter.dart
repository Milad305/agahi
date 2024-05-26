import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constant/colors.dart';

class ItemCityFilter extends StatelessWidget {
  const ItemCityFilter({
    required this.citymodel,
    super.key,
  });
  final CityModel citymodel;

  @override
  Widget build(BuildContext context) {
    var citysearchcontroller = Get.find<CitySearchController>();
    return Padding(
      padding: const EdgeInsets.only(right: 5, bottom: 5),
      child: TextButton(
          onPressed: () {
            if (citysearchcontroller.listSelectedCities.length > 1) {
              citysearchcontroller.listSelectedCities.removeWhere((element) {
                if (element.id == citymodel.id) {
                  var a = Get.find<MainController>().get_cities_from_storage();
                  a.removeWhere((element) => element.id == citymodel.id);
                  GetStorage('agahi').write('filter', a);
                  return true;
                } else {
                  return false;
                }
              });
            }
          },
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              backgroundColor: CRedLight,
              foregroundColor: CRed),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Text(citymodel.name!),
              const SizedBox(
                width: 5,
              ),
              Icon(
                size: 17,
                Icons.cancel,
                color: CRed,
              )
            ],
          )),
    );
  }
}
