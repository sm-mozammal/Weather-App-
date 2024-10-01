import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/colors.gen.dart';

class CustomSwitch extends StatefulWidget {
  final bool hasSwitchOn;
  final Function(bool)? onChanged;
  const CustomSwitch({super.key, this.onChanged, this.hasSwitchOn = false});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool hasSwitchOn = false;
  Duration time = const Duration(milliseconds: 300);

  Color activeSwitchBackgroundColor = AppColors.c123597;
  Color inactiveSwitchBackgroundColor = AppColors.bgColor;

  @override
  void initState() {
    hasSwitchOn = widget.hasSwitchOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            hasSwitchOn = !hasSwitchOn;

            if (widget.onChanged != null) {
              widget.onChanged!(hasSwitchOn);
            }
          });
        },
        child: uiDesign(
            activeSwitchBackgroundColor, inactiveSwitchBackgroundColor));
  }

  Widget uiDesign(Color activeBackground, Color inactiveBackground) {
    return AnimatedContainer(
      padding: EdgeInsets.all(2.sp),
      height: 26.h,
      width: 48.w,
      decoration: BoxDecoration(
          color: hasSwitchOn ? activeBackground : inactiveBackground,
          borderRadius: BorderRadius.circular(20.r)),
      duration: time,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedPositioned(
            left: hasSwitchOn ? 22.5.w : 0,
            //right: hasSwitchOn ? 0 : null,
            duration: time,
            child: AnimatedContainer(
              height: 20.h,
              width: 20.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: hasSwitchOn ? Colors.white : activeBackground,
                  shape: BoxShape.circle),
              duration: time,
            ),
          )
        ],
      ),
    );
  }
}
