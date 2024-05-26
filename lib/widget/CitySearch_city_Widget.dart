import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CityWidget extends StatefulWidget {
  const CityWidget({
    required this.citymodel,
    required this.index,
    super.key,
  });
  final CityModel citymodel;
  final int index;

  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  var citysearchcontroller = Get.find<CitySearchController>();
  bool? val = false;
  @override
  Widget build(BuildContext context) {
    for (var element in citysearchcontroller.listSelectedCities) {
      if (element.name == widget.citymodel.name) {
        val = true;
      }
    }
    return ListTile(
      onTap: () {
        runThis(!val!);
      },
      title: Text(widget.citymodel.name!),
      trailing: Checkbox(
        activeColor: Cprimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        value: val,
        onChanged: (value) {
          runThis(!val!);
        },
      ),
    );
  }

  runThis(value) {
    if (val == false) {
      List<CityModel> ciltyfilter =
          Get.find<MainController>().get_cities_from_storage();
      ciltyfilter.add(widget.citymodel);
      GetStorage('agahi').write("filter", ciltyfilter);
      citysearchcontroller.listSelectedCities.add(widget.citymodel);
    } else {
      if (citysearchcontroller.listSelectedCities.length > 1) {
        citysearchcontroller.listSelectedCities.removeWhere((element) {
          if (element.id == widget.citymodel.id) {
            return true;
          } else {
            return false;
          }
        });

        GetStorage('agahi')
            .write("filter", citysearchcontroller.listSelectedCities.value);
      }
    }
    setState(() {
      val = !val!;
    });
  }
}
