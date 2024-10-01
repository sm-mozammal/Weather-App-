import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helpers/ui_helpers.dart';
import '/helpers/navigation_service.dart';
import 'custom_button.dart';

deleteButtonDialouge(BuildContext context, String text, VoidCallback callback) {
  showDialog(
    builder: (context) => Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: .27.sh, maxWidth: .38.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // SvgPicture.asset(Assets.icons.apple),
              Text(
                'Are you sure?',
                style: TextFontStyle.headline16StyleMontserrat600.copyWith(color: Colors.black),
              ),
              UIHelper.verticalSpaceSmall,
              Text(
                text,
                style: TextFontStyle.headline12StyleMontserrat500.copyWith(color: AppColors.allPrimaryColor),
              ),
              UIHelper.verticalSpaceMedium,

              //Gravar Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customeButton(
                      name: 'No',
                      onCallBack: () {
                        NavigationService.goBack;
                      },
                      height: 30.h,
                      minWidth: .25.sw,
                      borderRadius: 8.r,
                      color: AppColors.cFFFFFF,
                      textStyle: TextFontStyle.headline12StyleMontserrat.copyWith(
                        color: AppColors.c000000,
                      ),
                      context: context),
                  UIHelper.horizontalSpaceSmall,
                  //Cancelar
                  customeButton(
                      name: 'Yes',
                      onCallBack: () {
                        callback();
                      },
                      height: 30.h,
                      minWidth: .25.sw,
                      borderRadius: 8.r,
                      color: AppColors.allPrimaryColor,
                      textStyle: TextFontStyle.headline12StyleMontserrat.copyWith(color: AppColors.white),
                      context: context),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    context: context,
  );
}
