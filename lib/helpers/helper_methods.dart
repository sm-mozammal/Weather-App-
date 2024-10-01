// ignore_for_file: unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import '../common_widgets/custom_button.dart';
import '../gen/colors.gen.dart';
import 'setup_di.dart';
import '/helpers/toast.dart';

import '../constants/app_constants.dart';
import '../constants/text_font_style.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<PopupMenuButtonState<String>> popUpGlobalkey =
    GlobalKey<PopupMenuButtonState<String>>();

Future<String?> networkImageToBase64(String imageUrl) async {
  http.Response response = await http.get(Uri.parse(imageUrl));
  final bytes = response.bodyBytes;

  // ignore: unnecessary_null_comparison
  return (bytes != null ? base64Encode(bytes) : null);
}

Future<void> setInitValue() async {
  // appData.writeIfNull(kKeyCountryCode, countriesCode[kKeyPortuguese]);
  appData.writeIfNull(kKeySelectedLocation, false);

  //default
  await appData.writeIfNull(kKeySelectedLat, 22.818285677915657);
  await appData.writeIfNull(kKeySelectedLng, 89.5535583794117);

  Completer<T> wrapInCompleter<T>(Future<T> future) {
    final completer = Completer<T>();
    future.then(completer.complete).catchError(completer.completeError);
    return completer;
  }

  Future<void> getInvisible() async {
    Future.delayed(const Duration(milliseconds: 500), () {});
  }

  Future<File> getLocalFile(String filename) async {
    File f = File(filename);
    return f;
  }
}

void showMaterialDialog(
  BuildContext context,
) {
  showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              "Do you want to exit the app?",
              textAlign: TextAlign.center,
              style: TextFontStyle.headline14StyleMontserrat,
            ),
            actions: <Widget>[
              customeButton(
                  name: "No",
                  onCallBack: () {
                    Navigator.of(context).pop(false);
                  },
                  height: 30.sp,
                  minWidth: .3.sw,
                  borderRadius: 30.r,
                  color: AppColors.cF0F0F0,
                  textStyle: GoogleFonts.montserrat(
                      fontSize: 17.sp,
                      color: AppColors.allPrimaryColor,
                      fontWeight: FontWeight.w700),
                  context: context),
              customeButton(
                  name: "Yes",
                  onCallBack: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  height: 30.sp,
                  minWidth: .3.sw,
                  borderRadius: 30.r,
                  color: AppColors.allPrimaryColor,
                  textStyle: GoogleFonts.montserrat(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  context: context),
            ],
          ));
}

void rotation() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

DateTime dateTimeFormatter(String dateTime) {
  // Create a DateTime object for the current date and time
  DateTime now = DateTime.now();

  // Format the DateTime object to a string in uppercase
  String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm').format(now).toUpperCase();

  // Print the formatted date string
  log(formattedDate);

  // Convert the formatted date string back to a DateTime object
  DateTime parsedDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(formattedDate);

  return parsedDateTime;
}

Future<void> initiInternetChecker() async {
  InternetConnectionChecker.createInstance(
          checkTimeout: const Duration(seconds: 1),
          checkInterval: const Duration(seconds: 2))
      .onStatusChange
      .listen((status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        appData.write("key", false);
        ToastUtil.showShortToast('Data connection is available.');
        break;
      case InternetConnectionStatus.disconnected:
        ToastUtil.showNoInternetToast();
        break;
    }
  });
}
