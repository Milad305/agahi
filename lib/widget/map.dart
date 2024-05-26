// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:agahi_app/screens/SelectMapScreen.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:latlong2/latlong.dart';

class LocationController extends GetxController {
  late Rx<LatLng> selectedLocation = LatLng(0.0, 0.0).obs;
  RxBool isSelected = false.obs;
  RxBool isPickingLocation = false.obs;
  final mapController = MapController();
  RxBool isLoading = false.obs;

  //current location
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      MySnackBar(
          "GPS دستگاه خود را روشن کنید!", Colors.yellow, Icon(Icons.gps_fixed));
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void updateSelectedLocation(LatLng location) {
    selectedLocation.value = location;
    print(location.latitude);
  }

  Future<void> saveLocation() async {
    await GetStorage('agahi').write("location",
        "${selectedLocation.value.latitude},${selectedLocation.value.longitude}");

    isSelected(true);
  }

  LatLng? readLocationfromdb() {
    isLoading(true);
    List<String> numbersList = [];
    double? lat;
    double? lang;
    var a = GetStorage('agahi').read("location");
    if (a != null) {
      numbersList = a.split(',');
      lat = double.parse(numbersList[0].toString());
      lang = double.parse(numbersList[1].toString());

      isLoading(false);
      return LatLng(lat, lang);
    } else {
      isLoading(false);
      return null;
    }

    // Convert the strings to integers
  }

  changeLocations() async {
    isSelected(false);
    await GetStorage('agahi').write("location",
        "${selectedLocation.value.latitude},${selectedLocation.value.longitude}");
    readSavedLocation();
  }

  readSavedLocation() async {
    LatLng? dbLocation = readLocationfromdb();
    if (dbLocation == null || dbLocation == LatLng(51.404343, 51.404343)) {
      isSelected(false);
    } else {
      selectedLocation.value = dbLocation;
      if (!isPickingLocation.value)
        isSelected(true);
      else
        isSelected(false);
      selectedLocation(dbLocation);
    }
  }
}

class LocationPicker extends StatefulWidget {
  final onlyShow;
  final LatLng? adsloc;
  final Function()? refreshPage;
  final LocationController locationController = Get.put(LocationController());
  LocationPicker(
      {super.key, this.onlyShow = false, this.adsloc, this.refreshPage}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await locationController.readSavedLocation();
    });
  }

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        setState(() {});
        return true;
      }),
      child: CustomScaffold(
        body: Obx(() {
          return locationController.isLoading.value
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    if (!locationController.isPickingLocation.value) {
                      locationController.isPickingLocation(true);
                      locationController.isSelected.value = false;
                    }
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: locationController.mapController,
                          options: MapOptions(
                              initialCenter: widget.onlyShow
                                  ? widget.adsloc!
                                  : locationController.selectedLocation.value ==
                                          LatLng(0, 0)
                                      ? LatLng(35.6783, 51.4161)
                                      : locationController
                                          .selectedLocation.value,
                              initialZoom: 18,
                              interactionOptions: InteractionOptions(
                                  enableMultiFingerGestureRace: true,
                                  flags: widget.onlyShow
                                      ? InteractiveFlag.doubleTapDragZoom |
                                          InteractiveFlag.doubleTapZoom |
                                          InteractiveFlag.flingAnimation |
                                          InteractiveFlag.pinchZoom |
                                          InteractiveFlag.scrollWheelZoom
                                      : InteractiveFlag.all),
                              onPositionChanged: (_, __) {
                                if (!locationController.isSelected.value) {
                                  print("changing");
                                  locationController.updateSelectedLocation(
                                      locationController.mapController.center);
                                }
                              },
                              onTap: ((tapPosition, point) {
                                if (!locationController
                                    .isPickingLocation.value) {
                                  locationController.isSelected(false);
                                  locationController.isPickingLocation(true);
                                }

                                if (locationController.isSelected.value) {
                                  locationController.changeLocations();
                                }
                              })),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                if (!locationController.isSelected.value &&
                                    !widget.onlyShow)
                                  Marker(
                                    width: 30.0,
                                    height: 30.0,
                                    child: Icon(
                                      Icons.location_on,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    point: locationController
                                        .selectedLocation.value,
                                  ),
                                if (locationController.isSelected.value ||
                                    widget.onlyShow)
                                  Marker(
                                      width: 30.0,
                                      height: 30.0,
                                      point: widget.onlyShow
                                          ? widget.adsloc!
                                          : locationController
                                              .selectedLocation.value,
                                      child: Icon(
                                        Icons.pin_drop,
                                        size: 30,
                                        color: Colors.blue,
                                      )),
                              ],
                            ),
                            RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  onTap: () async {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);
                                    double lat = position.latitude;
                                    double long = position.longitude;

                                    LatLng location = LatLng(lat, long);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        !widget.onlyShow
                            ? locationController.isPickingLocation.value
                                ? Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Handle saving the selected location

                                        locationController.saveLocation();
                                        locationController
                                            .isPickingLocation(false);
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green,
                                        ),
                                        child: Center(
                                            child: Text(
                                          "ذخیره لوکیشن",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ))
                                : locationController.isSelected.value
                                    ? Positioned(
                                        bottom: 16,
                                        left: 16,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle saving the selected location
                                            locationController.mapController
                                                .move(
                                                    locationController
                                                        .selectedLocation.value,
                                                    16);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.green,
                                            ),
                                            child: Center(
                                                child: Icon(
                                                    Icons.location_searching)),
                                          ),
                                        ))
                                    : Container()
                            : Container(),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}

class FullLocationPicker extends StatefulWidget {
  final onlyShow;
  final LatLng? adsloc;
  final Function()? refreshPage;
  final LocationController locationController = Get.put(LocationController());
  FullLocationPicker(
      {super.key, this.onlyShow = false, this.adsloc, this.refreshPage}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await locationController.readSavedLocation();
    });
  }

  @override
  State<FullLocationPicker> createState() => _FullLocationPickerState();
}

class _FullLocationPickerState extends State<FullLocationPicker> {
  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        setState(() {});
        return true;
      }),
      child: CustomScaffold(
        body: Obx(() {
          return locationController.isLoading.value
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    if (!locationController.isPickingLocation.value) {
                      locationController.isPickingLocation(true);
                      locationController.isSelected.value = false;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SelectMapScreen(
                              refreshPage: widget.refreshPage!,
                            );
                          });
                    }
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: locationController.mapController,
                          options: MapOptions(
                              initialCenter: widget.onlyShow
                                  ? widget.adsloc!
                                  : locationController.selectedLocation.value ==
                                          LatLng(0, 0)
                                      ? LatLng(35.6783, 51.4161)
                                      : locationController
                                          .selectedLocation.value,
                              initialZoom: 18,
                              interactionOptions: InteractionOptions(
                                  enableMultiFingerGestureRace: true,
                                  flags: widget.onlyShow
                                      ? InteractiveFlag.doubleTapDragZoom |
                                          InteractiveFlag.doubleTapZoom |
                                          InteractiveFlag.flingAnimation |
                                          InteractiveFlag.pinchZoom |
                                          InteractiveFlag.scrollWheelZoom
                                      : InteractiveFlag.all),
                              onPositionChanged: (_, __) {
                                if (!locationController.isSelected.value) {
                                  print("changing");
                                  locationController.updateSelectedLocation(
                                      locationController.mapController.center);
                                }
                              },
                              onTap: ((tapPosition, point) {
                                if (!locationController
                                    .isPickingLocation.value) {
                                  locationController.isSelected(false);
                                  locationController.isPickingLocation(true);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SelectMapScreen(
                                          refreshPage: widget.refreshPage!,
                                        );
                                      });
                                }

                                if (locationController.isSelected.value) {
                                  locationController.changeLocations();
                                }
                              })),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            MarkerLayer(
                              markers: [
                                if (!locationController.isSelected.value &&
                                    !widget.onlyShow)
                                  Marker(
                                    width: 30.0,
                                    height: 30.0,
                                    child: Icon(
                                      Icons.location_on,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    point: locationController
                                        .selectedLocation.value,
                                  ),
                                if (locationController.isSelected.value ||
                                    widget.onlyShow)
                                  Marker(
                                      width: 30.0,
                                      height: 30.0,
                                      point: widget.onlyShow
                                          ? widget.adsloc!
                                          : locationController
                                              .selectedLocation.value,
                                      child: Icon(
                                        Icons.pin_drop,
                                        size: 30,
                                        color: Colors.blue,
                                      )),
                              ],
                            ),
                            RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  onTap: () async {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);
                                    double lat = position.latitude;
                                    double long = position.longitude;

                                    LatLng location = LatLng(lat, long);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        !widget.onlyShow &&
                                locationController.isPickingLocation.value
                            ? Positioned(
                                bottom: 16,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () async {
                                    // Handle saving the selected location
                                    var location = await locationController
                                        .determinePosition();
                                    locationController.mapController.move(
                                        LatLng(location.latitude,
                                            location.longitude),
                                        16);
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: Icon(
                                            Icons.location_searching_rounded)),
                                  ),
                                ))
                            : Container(),
                        !widget.onlyShow
                            ? locationController.isPickingLocation.value
                                ? Positioned(
                                    bottom: 16,
                                    left: 16,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Handle saving the selected location

                                        locationController.saveLocation();
                                        locationController
                                            .isPickingLocation(false);
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green,
                                        ),
                                        child: Center(
                                            child: Text(
                                          "ذخیره لوکیشن",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ))
                                : locationController.isSelected.value
                                    ? Positioned(
                                        bottom: 16,
                                        left: 16,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle saving the selected location
                                            locationController.mapController
                                                .move(
                                                    locationController
                                                        .selectedLocation.value,
                                                    16);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.green,
                                            ),
                                            child: Center(
                                                child: Icon(
                                                    Icons.location_searching)),
                                          ),
                                        ))
                                    : Container()
                            : Container(),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
