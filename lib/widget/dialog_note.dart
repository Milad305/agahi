import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/controller/main_controller.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class DialogNote extends StatelessWidget {
  const DialogNote({super.key});

  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              textDirection: TextDirection.rtl,
              controller: maincontroller.textFieldDialogNote,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: 'یادداشت خود را وارد نمایید',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), gapPadding: 5)),
            ),
            Obx(() => maincontroller.isLoadingSubmitNote.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: Cprimary,
                      strokeWidth: 1,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      if (maincontroller.textFieldDialogNote.text.isNotEmpty) {
                        maincontroller.addNote();
                      } else {
                        MySnackBar(
                            'لطفا متن خود را وارد نمایید',
                            CwarningColor,
                            Icon(
                              Icons.warning_rounded,
                              color: CwarningColor,
                            ));
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Cprimary, foregroundColor: Cwhite),
                    child: const Text('ثبت یادداشت')))
          ],
        ),
      ),
    );
  }
}
