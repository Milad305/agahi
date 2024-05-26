import 'package:agahi_app/constant/colors.dart';
import 'package:agahi_app/constant/strings.dart';
import 'package:agahi_app/screens/bookmarks_screen.dart';
import 'package:agahi_app/screens/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';
import 'package:get/get.dart';

class BookmarkAndNotes extends StatelessWidget {
  const BookmarkAndNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: CustomScaffold(
          appBar: AppBar(
              titleTextStyle: const TextStyle(
                  fontSize: 15, fontFamily: 'iransans', color: Colors.white),
              title: SizedBox(
                width: Get.width,
                child: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('نشان ها و یادداشت ها'),
                ),
              ),
              backgroundColor: Cprimary,
              leading: IconButton(
                splashRadius: 20,
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              bottom: TabBar(indicatorColor: Cprimarytabbarindiactor, tabs: [
                Tab(
                  text: strNotes,
                  icon: const Icon(Icons.description),
                ),
                Tab(
                  text: strBookmarks,
                  icon: const Icon(Icons.bookmark),
                ),
              ])),
          body: const TabBarView(children: [NotesScreen(), BookmarksScreen()]),
        ),
      ),
    );
  }
}
