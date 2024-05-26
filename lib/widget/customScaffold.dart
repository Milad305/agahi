// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:agahi_app/controller/main_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CustomScaffold extends StatefulWidget {
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomInset;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  const CustomScaffold({
    Key? key,
    this.backgroundColor,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
  }) : super(key: key);

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold>
    with WidgetsBindingObserver {
  StreamSubscription? connectivitySubscription;
  MainController controller = Get.put(MainController());

  void _checkCurrentNetworkState() {
    Connectivity().checkConnectivity().then((connectivityResult) {
      controller.isNetworkDisabled.value.value =
          connectivityResult == ConnectivityResult.none;
    });
  }

  initStateFunc() {
    _checkCurrentNetworkState();

    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        print(result);
        controller.isNetworkDisabled.value.value =
            result == ConnectivityResult.none;
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initStateFunc();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _checkCurrentNetworkState();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.put(MainController());
    return Stack(
      // fit: StackFit.expand,
      children: [
        Scaffold(
          backgroundColor: widget.backgroundColor,
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          extendBody: widget.extendBody ?? false,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
          drawer: widget.drawer,
          endDrawer: widget.endDrawer,
          bottomSheet: widget.bottomSheet,
          appBar: widget.appBar,
          body: Container(
            height: Get.height,
            child: Column(
              children: [
                Obx(() {
                  return !controller.isinternet.value
                      ? Container(
                          color:
                              Colors.red, // Example color for offline indicator
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text(
                              "آفلاین هستید",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Container();
                }),
                Expanded(
                  child: widget.body ?? const SizedBox(),
                  // Use Expanded to avoid overflow
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

        /*Obx(
          () => controller.isNetworkDisabled.value.value
              ? Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Visibility(
                    visible: controller.isNetworkDisabled.value.value,
                    child: Scaffold(
                      body: Container(
                        child: Text("آفلاین هستید"),
                      ),
                    ),
                  ),
                )
              : Container(),
        )*/

