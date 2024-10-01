
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DegreeIndicator extends StatelessWidget {
  final String prefixText;
  bool degreeEnabled;
  DegreeIndicator({
    super.key,
    required this.prefixText,
    this.degreeEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          prefixText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Circular Std',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          degreeEnabled ? '°' : '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp, // Smaller font size for the degree symbol
            fontFamily: 'Circular Std',
            fontWeight: FontWeight.w400,
            height: 0.1, // Adjust height to align the degree symbol correctly
          ),
        ),
      ],
    );
  }
}
