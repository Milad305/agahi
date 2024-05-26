import 'package:accordion/accordion.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/controller/setting_controller.dart';
import 'package:agahi_app/widget/ofline_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../constant/colors.dart';
import '../widget/public_widget.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var settingcontroller = Get.find<SettingController>();
    settingcontroller.getQuestions();
    return SafeArea(
      child: CustomScaffold(
        body: Column(
          children: [
            /*  Obx(
              () {
                return Get.find<MainController>().isinternet.value == false
                    ? OflineMessage()
                    : Container();
              },
            ),*/
            CustomAppBar(
              bg_color: Cprimary,
              show_back: true,
              show_title: true,
              title: "سوالات متداول",
              title_icon: Icon(
                Icons.help,
                color: Cwhite,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(
                () => settingcontroller.isLoadingQuestions.value
                    ? Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 1.5, color: Cprimary),
                      )
                    : Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            Accordion(
                              maxOpenSections: 1,
                              contentBorderWidth: 2,
                              openAndCloseAnimation: true,
                              contentBorderColor: Cprimary,
                              flipRightIconIfOpen: true,
                              rightIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black.withOpacity(.8),
                              ),
                              paddingListBottom: 0,
                              paddingListTop: 0,
                              headerPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              headerBackgroundColor:
                                  Theme.of(context).primaryColorLight,
                              children: [
                                ...List.generate(
                                    settingcontroller.listQuestions.length,
                                    (index) {
                                  var question =
                                      settingcontroller.listQuestions[index];
                                  return AccordionSection(
                                    contentBorderColor:
                                        Theme.of(context).primaryColorLight,
                                    contentBackgroundColor:
                                        Theme.of(context).primaryColorLight,
                                    header: Text(question.title ?? ''),
                                    content: Accordion(
                                      maxOpenSections: 1,
                                      contentBorderColor:
                                          Theme.of(context).primaryColorLight,
                                      headerBackgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      contentBorderRadius: 15,
                                      flipRightIconIfOpen: true,
                                      rightIcon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
                                      ),
                                      contentBackgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      children: question.child_Widgets(),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ],
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
