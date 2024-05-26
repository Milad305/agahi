import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

import '../controller/city_seatch_controller.dart';

class StateWidget extends StatelessWidget {
  const StateWidget({
    super.key,
    required this.index,
    required this.citysearchcontroller,
  });

  final CitySearchController citysearchcontroller;
  final index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        citysearchcontroller.showCities(true);
        citysearchcontroller.getCities(
            stateId: citysearchcontroller.listStates[index].id);
      },
      title: Text(citysearchcontroller.listStates[index].name!),
      trailing: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 17,
        color: Theme.of(context).highlightColor,
      ),
    );
  }
}
