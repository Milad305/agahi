import 'dart:async';
import 'dart:io';
import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/manage_ads_controller.dart';
import 'package:agahi_app/models/CategoryModel.dart';
import 'package:agahi_app/models/CityModel.dart';
import 'package:agahi_app/models/DistrictModel.dart';
import 'package:agahi_app/screens/SelectMapScreen.dart';
import 'package:agahi_app/screens/category_ads.dart';
import 'package:agahi_app/screens/my_ads.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:agahi_app/widget/dialog_city_state_addads.dart';
import 'package:agahi_app/widget/map.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import '../utils/widget_generator.dart';
import '../widget/widget.dart';

String formatPrice(double price) {
  String formattedPrice =
      intl.NumberFormat.currency(locale: 'en_US', symbol: '').format(price);
  // Remove currency symbol and decimal part
  formattedPrice = formattedPrice.substring(0, formattedPrice.indexOf('.'));
  return formattedPrice;
}

class SubmitAdsScreen extends StatefulWidget {
  CategoryModel cat;
  SubmitAdsScreen({Key? key, required this.cat}) : super(key: key);

  @override
  State<SubmitAdsScreen> createState() => _SubmitAdsScreenState();
}

class _SubmitAdsScreenState extends State<SubmitAdsScreen> {
  var addadscontroller = Get.find<AddAdsController>();
  refreshPage() {
    setState(() {
      widget.cat = addadscontroller.selectedCategory.value;
      addadscontroller = Get.find<AddAdsController>();
    });
  }

/*
  Future<void> getFromGallery() async {
    var imagePicker = ImagePicker();
    var addAdsController = Get.find<AddAdsController>();

    List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      for (var image in selectedImages) {
        File file = File(image.path);
        addAdsController.listPickedImages.add(file);
      }
    }
  }*/

  getFromGallery() async {
    var addadscontroller = Get.find<AddAdsController>();
    ImagePicker picker = ImagePicker();

    if (addadscontroller.listPickedImages.length <= 5) {
      var picked = await picker.pickImage(
          maxHeight: 500, maxWidth: 500, source: ImageSource.gallery);
      if (picked != null) {
        File f = File(picked.path);
        if (f.lengthSync() <= 3000000) {
          print("sizeeeeeeeeeeeeeeeee: ${f.lengthSync()}");
          addadscontroller.listPickedImages.add(f);
          addadscontroller.cropImage();
        } else
          // ignore: curly_braces_in_flow_control_structures
          MySnackBar(
              "حجم فایل کمتر از سه مگابایت باشد",
              CerrorColor,
              const Icon(
                Icons.error,
                color: Colors.red,
              ));
      }
    }
  }

  getFromCamera() async {
    var addadscontroller = Get.find<AddAdsController>();
    ImagePicker picker = ImagePicker();
    if (addadscontroller.listPickedImages.length <= 6) {
      var picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        File f = File(picked.path);

        addadscontroller.listPickedImages.add(f);
        addadscontroller.cropImage();
      }
      // addadscontroller.listPickedImages(await picker.pickMultiImage());
    }
  }

  @override
  void dispose() {
    Timer(Duration.zero, () {
      addadscontroller.clear();
    });
    super.dispose();
  }

  @override
  void initState() {
    addadscontroller.readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(
      height: 20,
    );

    return WillPopScope(onWillPop: () async {
      /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.find<AddAdsController>().getCategory();
        }); */
      addadscontroller.getCategory();
      //Get.find<MainController>().update();
      // addadscontroller.update();
      //addadscontroller.isCanBack(true);

      return Future(() => true);
    }, child: SafeArea(child: Obx(() {
      return Get.find<LocationController>().isPickingLocation.value
          ? SelectMapScreen(
              refreshPage: refreshPage,
            )
          : CustomScaffold(
              appBar: AppBar(
                title: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    IconButton(
                        onPressed: () {
                          addadscontroller.renewAddAdsPage();
                        },
                        icon: const Icon(Icons.refresh)),
                    Text(
                      'ثبت آگهی',
                      style: TextStyle(color: Cwhite, fontSize: 18),
                    ),
                  ],
                ),
                backgroundColor: Cprimary,
                foregroundColor: Cwhite,
                leading: IconButton(
                    highlightColor: Cwhite.withOpacity(.5),
                    splashRadius: 20,
                    onPressed: () async {
                      addadscontroller.getCategory();
                      addadscontroller.isCanBack(true);
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              body: Column(children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView(
                      shrinkWrap: false,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textDirection: TextDirection.rtl,
                            children: [
                              const Text("دسته بندی آگهی"),
                              const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                    onTap: (() {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            surfaceTintColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            insetPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 50,
                                                    horizontal: 20),
                                            child: ChangeCategory(
                                              refresh: refreshPage,
                                            ),
                                          );
                                        },
                                      );
                                    }),
                                    child: Container(
                                      height: 40,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Cprimary),
                                      child: Center(
                                        child: Obx(() {
                                          return addadscontroller
                                                  .isLoadingCitiesAndStates
                                                  .isFalse
                                              ? Center(
                                                  child: Text(
                                                    addadscontroller
                                                                .selectedCategory
                                                                .value
                                                                .name ==
                                                            null
                                                        ? 'انتخاب'
                                                        : '${addadscontroller.selectedCategory.value.name!}',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : const SizedBox();
                                        }),
                                      ),
                                    )),
                              ),
                              // SizedBox(
                              //   width: Get.width * .1,
                              // ),
                            ],
                          ),
                        ),
                        space,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textDirection: TextDirection.rtl,
                            children: [
                              const Text(
                                "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              const Text("محدوده آگهی"),
                              const Spacer(),
                              Expanded(
                                child: GestureDetector(
                                    onTap: (() {
                                      addadscontroller.isShowCity(false);
                                      addadscontroller.isShowDistrict(false);
                                      addadscontroller.getStates();
                                      Get.to(const DialogCityStateAddAds());
                                    }),
                                    child: Container(
                                      height: 40,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 2,
                                              color: addadscontroller
                                                  .cityColor.value),
                                          color: Cprimary),
                                      child: Center(
                                        child: Obx(() {
                                          return addadscontroller
                                                  .isLoadingCitiesAndStates
                                                  .isFalse
                                              ? Center(
                                                  child: Text(
                                                    addadscontroller
                                                                .selectedCity
                                                                .value
                                                                .name ==
                                                            null
                                                        ? 'انتخاب'
                                                        : addadscontroller
                                                                    .selectedDistrict
                                                                    .value
                                                                    .id ==
                                                                null
                                                            ? addadscontroller
                                                                .selectedCity
                                                                .value
                                                                .name!
                                                            : '${addadscontroller.selectedCity.value.name!}/${addadscontroller.selectedDistrict.value.name}',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : const SizedBox();
                                        }),
                                      ),
                                    )),
                              ),
                              // SizedBox(
                              //   width: Get.width * .1,
                              // ),
                            ],
                          ),
                        ),
                        space,
                        SubmitTextFieldWidget(
                            onChange: ((p0) {
                              addadscontroller.saveData();
                            }),
                            height: 40,
                            controller: addadscontroller.titleController,
                            color: addadscontroller.titleColor.value,
                            hint: 'عنوان را وارد نمایید',
                            isRequired: true,
                            title: 'عنوان'),
                        space,
                        addadscontroller.fixedPrice.value
                            ? Container()
                            : SubmitTextFieldWidget(
                                onChange: ((p0) {
                                  addadscontroller.saveData();
                                }),
                                height: 40,
                                textInputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyInputFormatter(),
                                ],
                                inputType: TextInputType.number,
                                controller: addadscontroller.priceController,
                                color: addadscontroller.priceColor.value,
                                hint: 'مبلغ را وارد نمایید',
                                isRequired: false,
                                title: 'مبلغ'),
                        space,
                        Row(
                          children: [
                            const Text("توافقی"),
                            const Spacer(),
                            Checkbox(
                              activeColor: Cprimary,
                              value: addadscontroller.fixedPrice.value,
                              onChanged: (value) {
                                addadscontroller.priceController.text = '';
                                addadscontroller.fixedPrice.value =
                                    !addadscontroller.fixedPrice.value;
                              },
                            ),
                            /*   const Spacer(),
                            const Text("مایلم معاوضه کنم"),
                            Checkbox(
                                activeColor: Cprimary,
                                value: addadscontroller.exchangeable.value,
                                onChanged: (value) {
                                  addadscontroller.exchangeable.value =
                                      !addadscontroller.exchangeable.value;
                                }), */
                          ],
                        ),
                        space,
                        Row(
                          children: [
                            const Text('راه ارتباطی:'),
                            Expanded(child: Obx(
                              () {
                                return DropdownButton(
                                  isExpanded: true,
                                  alignment: Alignment.center,
                                  value: addadscontroller.crl.value,
                                  items: const [
                                    DropdownMenuItem(
                                        value: ContactRadioList.both,
                                        child:
                                            Center(child: Text('تماس و چت'))),
                                    DropdownMenuItem(
                                        value: ContactRadioList.call,
                                        child: Center(child: Text('تماس '))),
                                    DropdownMenuItem(
                                        value: ContactRadioList.chat,
                                        child: Center(child: Text(' چت'))),
                                  ],
                                  onChanged: (value) {
                                    addadscontroller
                                        .crl(value as ContactRadioList);

                                    addadscontroller.saveData();
                                  },
                                );
                              },
                            ))
                          ],
                        ),
                        space,
                        ColumnBuilder(
                          itemCount: addadscontroller.listCurrentFields.length,
                          itemBuilder: (context, index) {
                            var item =
                                addadscontroller.listCurrentFields[index];
                            return item.get_widget();
                          },
                        ),
                        space,
                        Obx(() {
                          return SubmitTextFieldWidget(
                              onChange: ((p0) {
                                addadscontroller.saveData();
                                addadscontroller.descriptiontextlength.value =
                                    p0.length;
                              }),
                              counterText:
                                  '${addadscontroller.descriptiontextlength.value}/1000',
                              inputType: TextInputType.multiline,
                              maxlength: 1000,
                              maxline: 5,
                              controller:
                                  addadscontroller.descriptionController,
                              color: addadscontroller.descriptionColor.value,
                              hint: 'توضیحات را وارد نمایید',
                              isRequired: true,
                              title: 'توضیحات:');
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: Get.width,
                          height: 70,
                          child: Obx(() =>
                                  addadscontroller.listPickedImages.length == 10
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            const Row(
                                              children: [
                                                Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                Text("انتخاب تصاویر:"),
                                              ],
                                            ),
                                            const Spacer(),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: addadscontroller
                                                    .imageColor.value,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.camera,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  showBottomSheetExamples(
                                                      context,
                                                      getFromGallery,
                                                      getFromCamera);
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                              /* Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Cprimary,
                                              foregroundColor: Cwhite),
                                          onPressed: () {
                                            _getFromGallery();
                                          },
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Icon(
                                                Icons.collections,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'انتخاب از گالری',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Cprimary,
                                              foregroundColor: Cwhite),
                                          onPressed: () {
                                            _getFromCamera();
                                          },
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Icon(
                                                Icons.add_a_photo,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'انتخاب از دوربین',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                          */
                              ),
                        ),
                        Obx(
                          () => addadscontroller.listPickedImages.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  width: Get.width,
                                  height: 200,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    spacing:
                                        10, // Adjust spacing between images
                                    runSpacing:
                                        10, // Adjust spacing between rows
                                    children: List.generate(
                                      addadscontroller.listPickedImages.length,
                                      (index) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.file(
                                                  fit: BoxFit.cover,
                                                  File(addadscontroller
                                                      .listPickedImages[index]!
                                                      .path),
                                                ),
                                              ),
                                              Positioned(
                                                top: -10,
                                                left: -10,
                                                child: IconButton(
                                                  splashRadius: 1,
                                                  onPressed: () {
                                                    addadscontroller
                                                        .listPickedImages
                                                        .removeAt(index);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    color: Colors
                                                        .red, // Adjust cancel icon color
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Divider(
                                  height: 2,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'انتخاب محل روی نقشه',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("نمایش لوکیشن در آگهی"),
                            Checkbox(
                              value: addadscontroller.isShowLocation.value,
                              onChanged: (value) {
                                addadscontroller.isShowLocation(value);
                              },
                            ),
                          ],
                        ),
                        Container(
                          width: Get.width,
                          height: Get.height * .2,
                          child: LocationPicker(refreshPage: refreshPage),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  height: 50,
                  width: Get.width - 40,
                  child: ButtonAgahi(
                    child: Center(
                      child: Obx(() {
                        if (addadscontroller.submit_loading.value) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return Text(
                            "ثبت آگهی",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Cwhite),
                          );
                        }
                      }),
                    ),
                    func: () {
                      if (addadscontroller.titleController.text != '' &&
                          addadscontroller.descriptionController.text != "" &&
                          
                          addadscontroller.selectedCity.value.name != null &&
                          addadscontroller.listPickedImages.isNotEmpty) {
                        addadscontroller.titleColor(Colors.black);
                        addadscontroller.descriptionColor(Colors.black);
                        addadscontroller.priceColor(Colors.black);
                        addadscontroller.cityColor(Cprimary);

                        addadscontroller.submitAdd();
                      } else {
                        addadscontroller.listPickedImages.isEmpty
                            ? addadscontroller.imageColor(Colors.red)
                            : addadscontroller.imageColor(Cprimary);
                        addadscontroller.titleController.text == ''
                            ? addadscontroller.titleColor(Colors.red)
                            : addadscontroller.titleColor(Colors.black);
                        addadscontroller.descriptionController.text == ''
                            ? addadscontroller.descriptionColor(Colors.red)
                            : addadscontroller.descriptionColor(Colors.black);
                       /*  addadscontroller.priceController.text == ''
                            ? addadscontroller.priceColor(Colors.red)
                            : addadscontroller.priceColor(Colors.black); */
                        addadscontroller.selectedCity.value.name == null
                            ? addadscontroller.cityColor(Colors.red)
                            : addadscontroller.cityColor(Cprimary);
                        //show snackbar
                        MySnackBar("موارد لازم نباید خالی باشند!", Colors.red,
                            const Icon(Icons.remove_circle));
                      }
                    },
                  ),
                )
              ]),
            );
    })));
  }
}

class ChangeCategory extends StatelessWidget {
  void Function() refresh;
  final maincontroller = Get.find<MainController>();
  final addadscontroller = Get.find<AddAdsController>();
  ChangeCategory({super.key, required this.refresh}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addadscontroller.getCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isParent = true;
    return Obx(() {
      return maincontroller.isLoadingCategory.value
          ? Center(
              child:
                  CircularProgressIndicator(strokeWidth: 1.5, color: Cprimary),
            )
          : WillPopScope(
              onWillPop: () {
                maincontroller.getBackCategory();
                return Future(() => true);
              },
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Cprimary,
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Row(
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.list_alt_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'ثبت آگهی',
                                style: TextStyle(color: Colors.white),
                              )
                            ]),
                      ),
                      Expanded(
                        child: Obx(() => addadscontroller
                                .isLoadingCategory.value
                            ? Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5, color: Cprimary),
                              )
                            : ListView.builder(
                                itemCount: addadscontroller.listCategory.length,
                                itemBuilder: (context, index) {
                                  CategoryModel cm =
                                      addadscontroller.listCategory[index];
                                  return ListTile(
                                    onTap: () {
                                      addadscontroller.isCanBack(false);
                                      if (cm.features!.length > 0 && isParent) {
                                        addadscontroller.listCurrentFields
                                            .value = cm.features!;
                                      } else if (isParent) {
                                        addadscontroller
                                            .listCurrentFields.value = [];
                                      }
                                      if (cm.features!.length > 0 &&
                                          !isParent) {
                                        for (int i = 0;
                                            i < cm.features!.length;
                                            i++) {
                                          addadscontroller.listCurrentFields
                                              .add(cm.features![i]);
                                        }
                                      }
                                      if (cm.childsCount == 0) {
                                        addadscontroller
                                            .selectedCategoryId(cm.id);
                                        addadscontroller
                                            .selectedCity(CityModel());
                                        addadscontroller
                                            .selectedDistrict(DistrictModel());
                                        addadscontroller.selectedCategory(cm);
                                        refresh();
                                        Get.back();

                                        /*  Get.back();
                                            Get.back();
                                            Get.to(SubmitAdsScreen(
                                              cat: cm,
                                            )) */
                                        ;
                                      } else {
                                        isParent = false;
                                        addadscontroller
                                            .getCategoryChild(cm.id!);
                                      }
                                    },
                                    title: Text(cm.name!),
                                    trailing: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  );
                                },
                              )),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}

void showBottomSheetExamples(
    BuildContext context, getFromGallery(), getFromCamera()) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'انتخاب تصویر',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                children: [
                  ListTile(
                      title: const Text('از گالری'),
                      // Replace with the actual phone number
                      leading: const Icon(Icons.image),
                      onTap: () {
                        getFromGallery();
                      }),
                  ListTile(
                      title: const Text('از دوربین'),
                      // Replace with the actual phone number
                      leading: const Icon(Icons.camera_alt),
                      onTap: () async {
                        getFromCamera();
                      }),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

class CurrencyInputFormatter extends TextInputFormatter {
  final validationRegex = RegExp(r'^[\d,]*\.?\d*$');

  final replaceRegex = RegExp(r'[^\d\.]+');

  static const fractionalDigits = 2;

  static const thousandSeparator = ',';

  static const decimalSeparator = '.';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!validationRegex.hasMatch(newValue.text)) {
      return oldValue;
    }

    final newValueNumber = newValue.text.replaceAll(replaceRegex, '');

    var formattedText = newValueNumber;

    /// Add thousand separators.

    var index = newValueNumber.contains(decimalSeparator)
        ? newValueNumber.indexOf(decimalSeparator)
        : newValueNumber.length;

    while (index > 0) {
      index -= 3;

      if (index > 0) {
        formattedText = formattedText.substring(0, index) +
            thousandSeparator +
            formattedText.substring(index, formattedText.length);
      }
    }

    /// Limit the number of decimal digits.

    final decimalIndex = formattedText.indexOf(decimalSeparator);

    var removedDecimalDigits = 0;

    if (decimalIndex != -1) {
      var decimalText = formattedText.substring(decimalIndex + 1);

      if (decimalText.isNotEmpty && decimalText.length > fractionalDigits) {
        removedDecimalDigits = decimalText.length - fractionalDigits;

        decimalText = decimalText.substring(0, fractionalDigits);

        formattedText = formattedText.substring(0, decimalIndex) +
            decimalSeparator +
            decimalText;
      }
    }

    /// Check whether the text is unmodified.

    if (oldValue.text == formattedText) {
      return oldValue;
    }

    /// Handle moving cursor.

    final initialNumberOfPrecedingSeparators =
        oldValue.text.characters.where((e) => e == thousandSeparator).length;

    final newNumberOfPrecedingSeparators =
        formattedText.characters.where((e) => e == thousandSeparator).length;

    final additionalOffset =
        newNumberOfPrecedingSeparators - initialNumberOfPrecedingSeparators;

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset +
              additionalOffset -
              removedDecimalDigits),
    );
  }
}
