import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/colors.dart';

class UpdataApp extends StatelessWidget {
  const UpdataApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Container(
                      width: Get.width,
                      child: Image.asset("assets/images/update.jpeg"))),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "نسخه برنامه شما قدیمی میباشد!\n برای استفاده برنامه را بروزرسانی کنید!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Cprimary, Cprimary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: MaterialButton(
                      child: const Text(
                        "بروزرسانی",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        /* String url =
                            'https://cafebazaar.ir/app/ir.salamatiman.app?l=en';
                        // ignore: deprecated_member_use
                        if (await canLaunch(url)) {
                          // ignore: deprecated_member_use
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }*/
                      },
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
