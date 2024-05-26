import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/constant/classess.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/models/NoteModel.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

import '../controller/account_contoller.dart';
import '../controller/main_controller.dart';
import '../widget/widget.dart';
import 'show_ads_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var accountcontroller = Get.find<AccountController>();
    var maincontroller = Get.find<MainController>();
    accountcontroller.getNotes();
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Obx(
        () => accountcontroller.isLoadingNotes.value
            ? Center(
                child: CircularProgressIndicator(
                    strokeWidth: 1.5, color: Cprimary),
              )
            : accountcontroller.listNotes.isEmpty
                ? const Center(
                    child: Text('اطلاعاتی برای نمایش وجود ندارد'),
                  )
                : ListView.builder(
                    itemCount: accountcontroller.listNotes.length,
                    itemBuilder: (context, index) {
                      NoteModel ntmodel = accountcontroller.listNotes[index];
                      return Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            BoxAgahi(
                              isLadder: maincontroller.listAds[index].ladder!,
                              func: () {
                                maincontroller.adsModel(ntmodel.ads);
                                //Get.toNamed('/showad');
                                Get.to(ShowAdsScreen(ads: ntmodel.ads!));
                              },
                              title: ntmodel.ads?.title ?? '',
                              text_dovom: '',
                              text_qeymat: ntmodel.ads?.getprice() ?? '',
                              text_date: ntmodel.ads?.createdAt
                                      .toString()
                                      .get_created_at() ??
                                  '',
                              image: ntmodel.ads?.getPreviewImage(),
                              left_right: 0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                textDirection: TextDirection.rtl,
                                children: [
                                  IconButton(
                                      splashRadius: 1,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DialogueCancelMassage(
                                              text:
                                                  'از حذف یادداشت اطمینان دارید ؟',
                                              deletefunc: () {
                                                Get.back();
                                                ApiProvider()
                                                    .deleteNote(ntmodel.id!)
                                                    .then((res) {
                                                  if (res.isOk) {
                                                    MySnackBar(
                                                        res.body['data'],
                                                        CerrorColor,
                                                        Icon(
                                                          Icons.delete_sweep,
                                                          color: CerrorColor,
                                                        ));
                                                  }
                                                  accountcontroller.getNotes();
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_rounded,
                                        color: CRed,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Expanded(
                                          child: Text(
                                        ntmodel.description ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
