// ignore_for_file: non_constant_identifier_names, unused_local_variable, invalid_use_of_protected_member
import 'package:agahi_app/controller/manage_ads_controller.dart';
import 'package:agahi_app/models/ImageModel.dart';
import 'package:agahi_app/models/draft_ads_model.dart';
import 'package:agahi_app/screens/manage_ads_screen.dart';
import 'package:agahi_app/screens/my_ads.dart';
import 'package:agahi_app/screens/submit_ads_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/models/CategoryFeature.dart';
import 'package:agahi_app/models/CategoryModel.dart';
import 'package:agahi_app/models/DistrictModel.dart';
import 'package:agahi_app/models/PlanModel.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import '../api/api.dart';
import '../constant/classess.dart';
import '../constant/colors.dart';
import '../models/CityModel.dart';
import '../models/StateModel.dart';
import '../widget/MySncakBar.dart';

class AddAdsController extends GetxController {
  var isLoadingCategory = false.obs;
  var isShowCity = false.obs;
  var descriptiontextlength = 0.obs;
  var isShowDistrict = false.obs;
  var isLoadingCitiesAndStates = false.obs;
  var listCities = <CityModel>[].obs;
  var listStates = <StateModel>[].obs;
  var listDistricts = <DistrictModel>[].obs;
  var listCategory = <CategoryModel>[].obs;
  var listWidgets = <Widget>[].obs;
  var listPlans = <PlanModel>[].obs;
  var isShowLocation = false.obs;
  var listSelectedPlans = <PlanModel>[].obs;
  var isSelectedCategory = false.obs;
  var refreshList = false.obs;
  var isLoadingForLink = false.obs;
  var isCanBack = true.obs;
  var selectedCategoryId = 0.obs;
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;
  var priceValue = 0.obs;
  var listCurrentFields = <CategoryFeature>[].obs;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var crl = ContactRadioList.both.obs;
  var listPickedImages = <File?>[].obs;
  var refreshWidget = false.obs;
  var selectedCity = CityModel().obs;
  var selectedDistrict = DistrictModel().obs;
  RxMap selectedValues = <String, String>{}.obs;
  RxMap items = {}.obs;
  var submit_loading = false.obs;
  var mainScontroller = Get.find<MainController>();
  Rx<Color> titleColor = Colors.black.obs;
  Rx<Color> imageColor = Cprimary.obs;
  Rx<Color> priceColor = Colors.black.obs;
  Rx<Color> descriptionColor = Colors.black.obs;
  Rx<Color> cityColor = Cprimary.obs;
  var exchangeable = false.obs;
  var fixedPrice = false.obs;
  var adsArea = false.obs;
  setEditPage(AdsModel ads) {
    titleController.text = ads.title!;
    descriptionController.text = ads.description!;
    priceController.text =
        ads.price.toString() != "-1" ? ads.price.toString() : "";
    fixedPrice.value = ads.price.toString() == "-1" ? true : false;
    crl(adsContactPicker(ads.contact!));
    imagesDownloader(ads.images!);
    selectedCity.value = ads.city!;

    ads.district != null ? selectedDistrict.value = ads.district! : null;

    refreshWidget(false);
    submit_loading(false);
  }

  String getImageName(String url) {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.last;
  }

// Add the below function inside your working class
  Future cropImage() async {
    if (listPickedImages.last != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: listPickedImages.last!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 50,
          maxHeight: 500,
          maxWidth: 500,
          uiSettings: [
            AndroidUiSettings(
                toolbarWidgetColor: Colors.white,
                backgroundColor: Colors.black,
                toolbarColor: Colors.black,
                //toolbarColor: Colors.green,

                activeControlsWidgetColor: Colors.green,
                cropFrameStrokeWidth: 2,
                hideBottomControls: true,
                toolbarTitle: 'برش تصویر',
                cropGridColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true),
            IOSUiSettings(title: 'بریدن تصویر')
          ]);

      if (cropped != null) {
        print("sizeeeeeeeeeeeeeeeee: ${File(cropped.path).lengthSync()}");
        listPickedImages.last = File(cropped.path);
      } else {
        listPickedImages.removeLast();
      }
    }
  }

  imagesDownloader(List<ImageModel> images) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      for (int i = 0; i < images.length; i++) {
        // Download image
        final http.Response response = await http
            .get(Uri.parse('${ApiProvider().domain}${images[i].image}'));
        Uint8List bytes = response.bodyBytes;

        // Create an image name
        var filename = '${dir.path}/${getImageName(images[i].image!)}';
        // Save to filesystem
        final file = File(filename);
        await file.writeAsBytes(response.bodyBytes);
        listPickedImages.add(file);
      }

      // Get temporary directory

      // Create an image name
      // var filename = '${dir.path}/SaveImage${random.nextInt(100)}.png';
    } catch (e) {
      print(e);
    }
  }

  adsContactPicker(int contact) {
    if (contact == 1) {
      return ContactRadioList.chat;
    } else if (contact == 2) {
      return ContactRadioList.both;
    } else {
      return ContactRadioList.call;
    }
  }

/*   Rx<LatLng> selectedLocation = LatLng(0, 0).obs;

  void updateSelectedLocation(LatLng location) {
    selectedLocation.value = location;
  }

  Future<void> saveLocation() async {
    // Implement your logic to save the selected location
    print('Selected Location: ${selectedLocation.value}');
    // You may want to navigate back to the previous screen or perform other actions here.
  }
 */
  void clear() {
    isLoadingCategory(false);
    //listCategory.clear();
    listWidgets.clear();
    isSelectedCategory(false);
    selectedCategoryId(0);
    listCurrentFields.clear();
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    crl(ContactRadioList.both);
    listPickedImages.clear();
    refreshWidget(false);
    submit_loading(false);
  }

  String contactSelector() {
    if (crl.value == ContactRadioList.chat) {
      return 'chat';
    } else if (crl.value == ContactRadioList.call) {
      return 'call';
    } else {
      return 'both';
    }
  }

  ContactRadioList contactInventor(String contact) {
    if (contact == 'chat') {
      return ContactRadioList.chat;
    } else if (contact == 'call') {
      return ContactRadioList.call;
    } else {
      return ContactRadioList.both;
    }
  }

  void saveData() {
    var imagesArr = <String>[]; // Assuming imagesArr contains paths
    var title = titleController.text;
    var description = descriptionController.text;
    var contact = contactSelector();
    var categoryId = selectedCategoryId.value;
    var price = priceController.text;
    var fields = [];
    var lang = Get.find<LocationController>().selectedLocation.value.longitude;
    var lat = Get.find<LocationController>().selectedLocation.value.latitude;

    // Assuming listPickedImages is a list of File paths
    listPickedImages.forEach((element) {
      imagesArr.add(element!.path);
    });

    listCurrentFields.forEach((element) {
      var d = {
        "label": element.name,
        "value": (element.additionalData != null &&
                element.additionalData!.isNotEmpty)
            ? selectedValues["${element.key}"]
            : element.textEditController!.text,
        "key": element.key,
        "type": element.type,
      };
      fields.add(json.encode(d));
    });

    var ad = Ad(
      imagesArr: imagesArr,
      title: title,
      description: description,
      contact: contact,
      categoryId: categoryId,
      price: price,
      fields: fields,
      lang: lang,
      lat: lat,
    );

    // Save to GetStorage
    final getStorage = GetStorage('agahi');
    getStorage.write('draftad', ad.toJson());
  }

  readData() {
    final getStorage = GetStorage('agahi');
    final jsonData = getStorage.read('draftad');
    if (jsonData != null) {
      Ad draft = Ad.fromJson(jsonData);
      for (int i = 0; i < draft.fields.length; i++) {
        Map<String, dynamic> jsonMap = json.decode(draft.fields[i]);

        // Extract the value associated with the key "key"
        dynamic key = jsonMap['key'];
        var value = jsonMap['value'];
        for (int j = 0; j < listCurrentFields.value.length; j++) {
          if (listCurrentFields.value[j].key == key) {
            listCurrentFields.value[j].textEditController!.text = value ?? '';
            selectedValues["$key"] =
                value ?? listCurrentFields.value[j].additionalData![0]['title'];
          }
        }
      }
      /* Get.find<LocationController>().selectedLocation.value =
          LatLng(draft.lat ?? 51.404343, draft.lang ?? 35.715298); */
      // Map<String, dynamic> jsonMap = json.decode(draftFormData.fields[5].value);

      // Extract the value associated with the key "key"
      // dynamic keyValue = jsonMap['key'];

      // print(keyValue);
      // Replace the draft values
      // Extract values and update your UI elements accordingly
      crl.value = contactInventor(draft.contact);
      selectedCategoryId(int.parse(draft.categoryId.toString()));

      titleController.text = draft.title;
      descriptionController.text = draft.description;
      priceController.text = draft.price;
      // Update other UI elements based on the FormData fields
    }
    /*for (int i = 0; i < draft.fields.length; i++) {
        if (draft.fields[i].key == "fields") {
          Map<String, dynamic> jsonMap = json.decode(draft.fields[i].value);

          // Extract the value associated with the key "key"
          dynamic key = jsonMap['key'];
          var value = jsonMap['value'];
          for (int j = 0; j < listCurrentFields.value.length; j++) {
            if (listCurrentFields.value[j].key == key) {
              listCurrentFields.value[j].textEditController!.text = value;
              selectedValues["$key"] = value;
            }
          }
        } else if (draft.fields[i].key == "title") {
          titleController.text = draft.fields[i].value;
        } else if (draft.fields[i].key == "description") {
          descriptionController.text = draft.fields[i].value;
        } else if (draft.fields[i].key == "price") {
          priceController.text = draft.fields[i].value;
        } else if (draft.fields[i].key == "category_id") {
          selectedCategoryId(int.parse(draft.fields[i].value));
        } else if (draft.fields[i].key == "contact") {
          print(draft.fields[i].value);
          List<String> parts = draft.fields[i].value.split('.');
          //for example both
          String enumValueName = parts[1];

          ContactRadioList enumValue = ContactRadioList.values.firstWhere(
            (e) => e.toString().split('.').last == enumValueName,
            orElse: () => ContactRadioList.both, // Default value if not found
          );

          crl(enumValue);
        } /*else if (draftFormData.fields[i].key == "city") {
          Map<String, dynamic> jsonMap = json.decode(draftFormData.fields[i].value.toString());


          selectedCity(CityModel.fromJson(jsonMap));
        } else if (draftFormData.fields[i].key == "district") {
          /*  selectedDistrict(DistrictModel.fromJson(
              json.decode(draftFormData.fields[i].value)));*/
        } */
      }
     
    } else {
      return null;
    }*/
  }

  renewAddAdsPage() {
    clear();
    GetStorage('agahi').remove('draftad');
  }

  void submitAdd() {
    var images_arr = <MultipartFile>[];
    var title = titleController.text;
    var description = descriptionController.text;
    var contact = crl.value;
    var category_id = selectedCategory.value.id;
    var price = priceController.text.isEmpty ? "-1" : priceController.text;

    listPickedImages.forEach((element) {
      var image_path = (element as File).path;
      File file = File(image_path);
      images_arr.add(MultipartFile(file, filename: file.uri.pathSegments.last));
    });
    var fields = [];
    listCurrentFields.forEach((element) {
      var d = {
        "label": element.name,
        "value":
            (element.additionalData != null && element.additionalData != [])
                ? selectedValues["${element.key}"]
                : element.textEditController!.text,
        "key": element.key,
        "type": element.type,
      };
      fields.add(json.encode(d));
    });

    submitAds(
        city: selectedCity.value.id,
        title: title,
        description: description,
        contact: contact.index,
        price: int.parse(removeNonNumeric(price)),
        lang: !isShowLocation.value
            ? 0.0
            : Get.find<LocationController>().selectedLocation.value.longitude,
        lat: !isShowLocation.value
            ? 0.0
            : Get.find<LocationController>().selectedLocation.value.latitude,
        category_id: category_id,
        images: images_arr,
        fields: fields,
        district: selectedDistrict.value.id);
  }

  void editAds(adsId) {
    var images_arr = <MultipartFile>[];
    var title = titleController.text;
    var description = descriptionController.text;
    var contact = crl.value;
    var category_id = selectedCategoryId.value;
    var price = priceController.text == "" ? "-1" : priceController.text;

    listPickedImages.forEach((element) {
      var image_path = (element as File).path;
      File file = File(image_path);
      images_arr.add(MultipartFile(file, filename: file.uri.pathSegments.last));
    });
    var fields = [];
    listCurrentFields.forEach((element) {
      var d = {
        "label": element.name,
        "value":
            (element.additionalData != null && element.additionalData != [])
                ? selectedValues["${element.key}"]
                : element.textEditController!.text,
        "key": element.key,
        "type": element.type,
      };
      fields.add(json.encode(d));
    });

    saveEditAds(
        id: adsId,
        city: selectedCity.value.id,
        title: title,
        description: description,
        contact: contact.index,
        price: int.parse(price),
        lang: !isShowLocation.value
            ? 0.0
            : Get.find<LocationController>().selectedLocation.value.longitude,
        lat: !isShowLocation.value
            ? 0.0
            : Get.find<LocationController>().selectedLocation.value.latitude,
        category_id: category_id,
        images: images_arr,
        fields: fields,
        district: selectedDistrict.value.id);
  }

  void getStates() {
    isLoadingCitiesAndStates(true);
    listStates.clear();
    var tmp = [];
    ApiProvider().getStates().then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listStates.add(StateModel.fromJson(element));
        }

        isLoadingCitiesAndStates(false);
      } else {
        print('State Controller Error');
      }
    });
  }

  void getCities(int stateId) {
    isLoadingCitiesAndStates(true);
    listCities.clear();
    var tmp = [];
    ApiProvider().getCity(stateId: stateId).then((res) {
      if (res.body != null) {
        tmp = res.body;
        for (var element in tmp) {
          listCities.add(CityModel.fromJson(element));
        }

        isLoadingCitiesAndStates(false);
      } else {
        print('City Controller Error');
      }
    });
  }

  getCategory() {
    isSelectedCategory(false);
    listCategory.clear();
    isLoadingCategory(true);
    listCategory.clear();
    ApiProvider().getCategory().then((res) {
      if (res.isOk) {
        List lst = res.body['data'];
        for (var element in lst) {
          listCategory.add(CategoryModel.fromJson(element));
        }
        isLoadingCategory(false);
      } else {
        MySnackBar(
            res.body['message'] ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
    Get.find<AddAdsController>().update();
  }

  void getCategoryChild(int id) {
    isLoadingCategory(true);
    listCategory.clear();
    ApiProvider().getCategory(categoryid: id).then((res) {
      if (res.isOk) {
        isLoadingCategory(false);
        List lst = res.body['data'];
        for (var element in lst) {
          listCategory.add(CategoryModel.fromJson(element));
        }
      } else {
        MySnackBar(
            res.body['message'] ?? 'خطا در ارتباط',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void submitAds(
      {String? title,
      String? description,
      int? price,
      int? category_id,
      int? contact,
      int? city,
      List<MultipartFile>? images,
      List? fields,
      int? district,
      double? lang,
      double? lat,
      bool? exchanable,
      bool? isFixedPrice}) async {
    submit_loading(true);
    await ApiProvider()
        .submitAds(
            exchanable: exchangeable.value,
            isFixedPrice: fixedPrice.value,
            city: city,
            title: title,
            description: description,
            price: price,
            category_id: category_id,
            contact: contact,
            images: images,
            fields: fields,
            district: district,
            lng: lang,
            lat: lat)
        .then(
      (value) {
        submit_loading(false);
        if (value.isOk) {
          renewAddAdsPage();
          var json = jsonDecode(value.bodyString!);
          AdsModel ads = AdsModel.fromJson(json["data"]);
          if (ads.status == 3) {
            Get.put(ManagerAdsController());
            if (ads.category!.plan == 1) {
              Get.dialog(AlertDialog(
                content: Container(
                  height: 150,
                  child: Column(
                    children: [
                      const Text("ارسال در این دسته بندی رایگان نیست"),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const Text("تومان "),
                          Text(
                            formatPrice(
                                double.parse(ads.category!.fee.toString())),
                            style: TextStyle(
                              color: Cprimary,
                            ),
                          ),
                          const Spacer(),
                          const Text(":هزینه آگهی "),
                        ],
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: (() {
                            //go for payment
                            Get.offAll(() => MyAdsScreen());
                            Get.find<ManagerAdsController>().buyAds(ads.id!);
                            Get.find<ManagerAdsController>().update();
                          }),
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Cprimary),
                            child: const Center(
                                child: Center(
                              child: Text(
                                "پرداخت و انتشار",
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
            } else {
              Get.dialog(
                  useSafeArea: false,
                  Dialog(
                    insetPadding: EdgeInsets.zero,
                    child: SizedBox(
                      height: 250,
                      width: Get.width * .9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              ".شما به سقف درج آگهی رایگان خود رسیده اید",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "آگهی شما ثبت و در صف پرداخت قرار گرفت میتوانید در صورت لزوم از طریق مسیر آگهی های من در حساب کاربری نیز اقدام به تکمیل مراحل پرداخت نمایید",
                                textAlign: TextAlign.justify,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(color: Cprimary),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                const Text("تومان "),
                                Text(
                                  formatPrice(double.parse(
                                      ads.category!.fee.toString())),
                                  style: TextStyle(
                                    color: Cprimary,
                                  ),
                                ),
                                const Spacer(),
                                const Text(":هزینه ثبت آگهی "),
                              ],
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: GestureDetector(
                                onTap: (() {
                                  //go for payment
                                  Get.offAll(() => MyAdsScreen());
                                  Get.find<ManagerAdsController>()
                                      .buyAds(ads.id!);
                                  Get.find<ManagerAdsController>().update();
                                }),
                                child: Container(
                                  height: 40,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Cprimary),
                                  child: Center(child: Center(
                                    child: GetBuilder<ManagerAdsController>(
                                        builder: (controller) {
                                      return controller.isLoadingForLink.value
                                          ? const SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Text(
                                              "پرداخت و انتشار",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                    }),
                                  )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            }
          } else {
            MySnackBar(
                "با موفقیت ثبت شد",
                CsuccessColor,
                Icon(
                  Icons.check_circle,
                  color: CsuccessColor,
                ));
            mainScontroller.bottomindex(0);
            Get.offNamed("/main");
            Get.toNamed('/myads');
            // Timer(const Duration(milliseconds: 500), () {
            //   mainScontroller.getMyAds();
            // });
          }
        } else {
          MySnackBar(
              "مشکلی در درج آگهی پیش آمده مجددا تلاش کنید",
              CwarningColor,
              Icon(
                Icons.warning_rounded,
                color: CwarningColor,
              ));
        }
      },
    ).onError(
      (error, stackTrace) {
        submit_loading(false);
      },
    );
  }

  void saveEditAds({
    int? id,
    String? title,
    String? description,
    int? price,
    int? category_id,
    int? contact,
    int? city,
    List<MultipartFile>? images,
    List? fields,
    int? district,
    double? lang,
    double? lat,
  }) async {
    submit_loading(true);
    ApiProvider()
        .saveEditAds(
            id: id,
            city: city,
            title: title,
            description: description,
            price: price,
            category_id: category_id,
            contact: contact,
            images: images,
            fields: fields,
            district: district,
            lng: lang,
            lat: lat)
        .then(
      (value) async {
        if (value.isOk) {
          mainScontroller.bottomindex(0);

          await mainScontroller.getMyAds();
          submit_loading(false);
          Get.back();
          Get.back();
        }
      },
    ).onError(
      (error, stackTrace) {
        submit_loading(false);
      },
    );
  }
}

String removeNonNumeric(String input) {
  if (input == "-1") return input;
  RegExp regExp = RegExp(r'[^\d]');
  print(input.replaceAll(regExp, ''));
  return input.replaceAll(regExp, '');
}
