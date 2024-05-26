import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

//--------------------!!!!!!!!!!!!!!!!!!!!!! ATTENTIONNNNN !!!!!!!!!!!!!!!!!!!!!-------------------------------
//rang asli barname
Color Cprimary = const Color.fromRGBO(0, 175, 148, 1);
Color Cprimarytabbarindiactor = Color.fromARGB(255, 0, 221, 188);
//rang asli barname kamrang
Color CprimaryLight = const Color.fromRGBO(215, 244, 243, 1);
//rang ghermez
Color CRed = const Color.fromRGBO(255, 63, 63, 1);
//rang ghermez kamrang
Color CRedLight = const Color.fromRGBO(255, 205, 205, 1);
//background color => Theme.of(context).scaffoldBackgroundColor
//black color  => Theme.of(context).cardColor

Color Cwhite = Colors.white;
Color Cblak = Colors.black;
Color CsuccessColor = Color.fromARGB(255, 29, 248, 13);
Color CwarningColor = Colors.amber;
Color CerrorColor = Colors.redAccent;
Color Clight = const Color.fromARGB(255, 244, 244, 244);
Color CbgLight = const Color.fromARGB(255, 247, 247, 247);
Color CbgDark = Color.fromARGB(255, 52, 52, 52);
Color CbgDark1 = Color.fromARGB(255, 77, 77, 77);
Color ChintLight = Color.fromARGB(255, 221, 221, 221);
Color ChhlightLight = Color.fromARGB(255, 128, 128, 128);
Color ChhlightDark = Color.fromARGB(255, 208, 208, 208);
Color ChintDark = Color.fromARGB(255, 116, 116, 116);

// int primary = 0xFF203F81;
// int accent = 0xFF4F67D8;
// // int bg_color = 0xFFEFEFEF;
// int bg_color = Color.fromARGB(255, 240, 240, 240).value;
// int yellow_color = 0xFFFFBE0F;
// int red_border = 0xFFF56646;
// int dark_orange = 0XFFF85E08;
// int orange = 0XFFF85E08;
// int bg_sheba = 0XFF706464;

//--------------------Linears-------------------------------
LinearGradient Klinear_primarytolight = LinearGradient(
    colors: [CprimaryLight, Cprimary],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter);

//--------------------Shadows-------------------------------
BoxShadow bs010 = BoxShadow(
    blurRadius: 5,
    offset: const Offset(0, 5),
    color: Colors.black.withOpacity(.1));
BoxShadow bs010r = BoxShadow(
    blurRadius: 5,
    offset: const Offset(0, -10),
    color: Colors.black.withOpacity(.1));

BoxShadow bs010red = BoxShadow(
    blurRadius: 35, offset: const Offset(0, 10), color: CRed.withOpacity(.2));
