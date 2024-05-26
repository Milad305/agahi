import 'package:agahi_app/api/api.dart';
import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/models/BookmarkModel.dart';
import 'package:agahi_app/models/NoteModel.dart';
import 'package:agahi_app/widget/MySncakBar.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  var listNotes = <NoteModel>[].obs;
  var listBookmarks = <BookmarkModel>[].obs;
  var isLoadingNotes = false.obs;
  var isLoadingBookmars = false.obs;

  void getNotes() {
    isLoadingNotes(true);
    ApiProvider().getNotes().then((res) {
      if (res.isOk) {
        listNotes.clear();
        List tmp = res.body;
        for (var element in tmp) {
          listNotes.add(NoteModel.fromJson(element));
        }
        isLoadingNotes(false);
      } else {
        MySnackBar(
            'خطا در ارسال اطلاعات',
            CwarningColor,
            Icon(
              Icons.warning_rounded,
              color: CwarningColor,
            ));
      }
    });
  }

  void getBookmarks() {
    ApiProvider().getBookmars().then((res) {
      listBookmarks.clear();
      List tmp = res.body;
      for (var element in tmp) {
        listBookmarks.add(BookmarkModel.fromJson(element));
      }
    });
  }
}
