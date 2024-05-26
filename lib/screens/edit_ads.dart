import 'dart:async';
import 'dart:io';
import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';

import 'package:agahi_app/models/AdsModel.dart';

import 'package:agahi_app/screens/SelectMapScreen.dart';

import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:agahi_app/widget/dialog_city_state_addads.dart';
import 'package:agahi_app/widget/map.dart';

import 'package:agahi_app/widget/public_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/widget_generator.dart';
import '../widget/widget.dart';

class EditAdsScreen extends StatefulWidget {
  var addadscontroller = Get.find<AddAdsController>();
  AdsModel ads;
  EditAdsScreen({Key? key, required this.ads}) {
    addadscontroller.setEditPage(ads);
  }

  @override
  State<EditAdsScreen> createState() => _EditAdsScreenState();
}

class _EditAdsScreenState extends State<EditAdsScreen> {
  var addadscontroller = Get.find<AddAdsController>();

  refreshPage() {
    setState(() {
      addadscontroller = Get.find<AddAdsController>();
    });
  }

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
    //addadscontroller.readDraftAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(
      height: 20,
    );
    widget.ads.lang != null && widget.ads.lang != 0.0
        ? addadscontroller.isShowLocation(true)
        : addadscontroller.isShowLocation(false);
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
                    Text(
                      'ویرایش آگهی',
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
                              Text(
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
                                    Get.to(DialogCityStateAddAds());
                                  }),
                                  child: Container(
                                    height: 40,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
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
                                                  addadscontroller.selectedCity
                                                              .value.name ==
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
                                  ),
                                ),
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
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                inputType: TextInputType.number,
                                controller: addadscontroller.priceController,
                                color: addadscontroller.priceColor.value,
                                hint: 'مبلغ را وارد نمایید',
                                isRequired: true,
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
                                  addadscontroller.listPickedImages.length == 5
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            Text("انتخاب تصاویر:"),
                                            Spacer(),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Cprimary,
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

                              /*Row(
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
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: addadscontroller
                                        .listPickedImages.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        width: 100,
                                        height: 100,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.file(
                                                    fit: BoxFit.cover,
                                                    File(addadscontroller
                                                        .listPickedImages[
                                                            index]!
                                                        .path)),
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
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: CerrorColor,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                        Obx(() {
                          return Row(
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
                          );
                        }),
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
                            "ویرایش آگهی",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Cwhite),
                          );
                        }
                      }),
                    ),
                    func: () {
                      if (addadscontroller.titleController.text != '' &&
                          addadscontroller.descriptionController.text != "" &&
                          addadscontroller.selectedCity.value.name != null) {
                        addadscontroller.editAds(widget.ads.id);
                      } else {
                        MySnackBar(
                            "محدوده آگهی,عنوان,قیمت و توضیحات لازم میباشند",
                            Colors.red,
                            const Icon(Icons.clear));
                      }
                    },
                  ),
                )
              ]),
            );
    })));
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


/*
 import 'dart:async';
import 'dart:io';
import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/add_ads_controller.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/models/AdsModel.dart';
import 'package:agahi_app/screens/ads_screen.dart';
import 'package:agahi_app/screens/main_screen.dart';
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
import '../utils/widget_generator.dart';
import '../widget/widget.dart';

class EditAdsScreen extends StatefulWidget {
  var addadscontroller = Get.find<AddAdsController>();
  AdsModel ads;
  EditAdsScreen({Key? key, required this.ads}) {
    addadscontroller.setEditPage(ads);
  }

  @override
  State<EditAdsScreen> createState() => _EditAdsScreenState();
}

class _EditAdsScreenState extends State<EditAdsScreen> {
  var addadscontroller = Get.find<AddAdsController>();

  _getFromGallery() async {
    var addadscontroller = Get.find<AddAdsController>();
    ImagePicker picker = ImagePicker();

    if (addadscontroller.listPickedImages.length <= 5) {
      var picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        File f = File(picked.path);

        addadscontroller.listPickedImages.add(f);
      }
    }
  }

  _getFromCamera() async {
    var addadscontroller = Get.find<AddAdsController>();
    ImagePicker picker = ImagePicker();
    if (addadscontroller.listPickedImages.length <= 5) {
      var picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        File f = File(picked.path);

        addadscontroller.listPickedImages.add(f);
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
    //addadscontroller.readDraftAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(
      height: 20,
    );

    return WillPopScope(
      onWillPop: () async {
        /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.find<AddAdsController>().getCategory();
        }); */
        //addadscontroller.getCategory();
        //Get.find<MainController>().update();
        // addadscontroller.update();
        //addadscontroller.isCanBack(true);

        return Future(() => true);
      },
      child: SafeArea(
          child: CustomScaffold(
        appBar: AppBar(
          title: Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'ثبت آگهی',
                style: TextStyle(color: Cwhite, fontSize: 18),
              )
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
            Obx(
                 () {
                  return Get.find<MainController>().isinternet.value == false ? OflineMessage() :Container();
                }
              ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                shrinkWrap: false,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        const Text("محدوده آگهی"),
                        const Spacer(),
                        Expanded(
                          child: GestureDetector(
                              onTap: (() {
                                addadscontroller.isShowCity(false);
                                addadscontroller.isShowDistrict(false);
                                addadscontroller.getStates();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      content: DialogCityStateAddAds(),
                                    );
                                  },
                                );
                              }),
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Cprimary),
                                child: Center(
                                  child: Obx(() {
                                    return addadscontroller
                                            .isLoadingCitiesAndStates.isFalse
                                        ? Center(
                                            child: Text(
                                              addadscontroller.selectedDistrict
                                                          .value.id ==
                                                      null
                                                  ? addadscontroller
                                                      .selectedCity.value.name!
                                                  : '${addadscontroller.selectedCity.value.name!}\\${addadscontroller.selectedDistrict.value.name}',
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
                      hint: 'عنوان را وارد نمایید',
                      title: 'عنوان'),
                  space,
                  SubmitTextFieldWidget(
                      onChange: ((p0) {
             
                        addadscontroller.saveData();
                      }),
                      height: 40,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      inputType: TextInputType.number,
                      controller: addadscontroller.priceController,
                      hint: 'مبلغ را وارد نمایید',
                      title: 'مبلغ'),
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
                                  child: Center(child: Text('تماس و چت'))),
                              DropdownMenuItem(
                                  value: ContactRadioList.call,
                                  child: Center(child: Text('تماس '))),
                              DropdownMenuItem(
                                  value: ContactRadioList.chat,
                                  child: Center(child: Text(' چت'))),
                            ],
                            onChanged: (value) {
                              addadscontroller.crl(value as ContactRadioList);
                       
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
                      var item = addadscontroller.listCurrentFields[index];
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
                        controller: addadscontroller.descriptionController,
                        hint: 'توضیحات را وارد نمایید',
                        title: 'توضیحات:');
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 70,
                    child: Obx(
                      () => addadscontroller.listPickedImages.length == 5
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ),
                  ),
                  Obx(
                    () => addadscontroller.listPickedImages.isEmpty
                        ? const SizedBox()
                        : SizedBox(
                            width: Get.width,
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  addadscontroller.listPickedImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: 100,
                                  height: 100,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.file(
                                              fit: BoxFit.cover,
                                              File(addadscontroller
                                                  .listPickedImages[index]!
                                                  .path)),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        left: -10,
                                        child: IconButton(
                                            splashRadius: 1,
                                            onPressed: () {
                                              addadscontroller.listPickedImages
                                                  .removeAt(index);
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: CerrorColor,
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  Container(
                    width: Get.width,
                    height: Get.height * .2,
                    child: LocationPicker(),
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
                      "ویرایش آگهی",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Cwhite),
                    );
                  }
                }),
              ),
              func: () {
                if (addadscontroller.titleController.text != '' &&
                    addadscontroller.descriptionController.text != "" &&
                    addadscontroller.priceController.text != "" &&
                    addadscontroller.selectedCity.value.name != null) {
                  addadscontroller.editAds(widget.ads.id);
                } else {
                  MySnackBar("محدوده آگهی,عنوان,قیمت و توضیحات لازم میباشند",
                      Colors.red, const Icon(Icons.clear));
                }
              },
            ),
          )
        ]),
      )),
    );
  }
}
 */