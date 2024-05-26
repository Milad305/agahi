import 'package:agahi_app/controller/city_seatch_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'itemCityFilter.dart';

class BottomAppbarCitySearch extends StatelessWidget
    implements PreferredSizeWidget {
  const BottomAppbarCitySearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var citysearchcontroller = Get.find<CitySearchController>();
    return SizedBox(
      height: 40,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const SizedBox(
            width: 5,
          ),
          const Text(
            'شهر های انتخاب شده:',
            textDirection: TextDirection.rtl,
          ),
          Expanded(
            child: Obx(() => Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: citysearchcontroller.listSelectedCities.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return ItemCityFilter(
                        citymodel:
                            citysearchcontroller.listSelectedCities[index],
                      );
                    },
                  ),
                )),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
