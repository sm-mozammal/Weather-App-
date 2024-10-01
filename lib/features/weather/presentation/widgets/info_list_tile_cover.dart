
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoListTileCover extends StatelessWidget {
  const InfoListTileCover({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.97, -0.26),
          end: Alignment(-0.97, 0.26),
          colors: [
            Color(0xff546EB9),
            Color(0xff8C9ED5),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.white.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: child,
    );
  }
}

