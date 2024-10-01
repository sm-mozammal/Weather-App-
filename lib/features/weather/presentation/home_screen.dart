// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/common_widgets/custom_switch.dart';
import 'package:weather_app/gen/assets.gen.dart';
import 'package:weather_app/gen/colors.gen.dart';
import 'package:weather_app/helpers/ui_helpers.dart';
import '../../../helpers/setup_di.dart';
import '../bloc/weather_bloc.dart';
import '../model/forecast_weather_info.dart';
import 'widgets/degree_indicator.dart';
import 'widgets/info_bar.dart';
import 'widgets/info_list_tile_cover.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<bool> isToday = ValueNotifier<bool>(true);
  final ValueNotifier<bool> areTempInF = ValueNotifier<bool>(false);
  static const String defaultWeatherImage =
      "https://static.vecteezy.com/system/resources/previews/012/629/893/original/cold-cloudy-day-3d-weather-icon-illustration-png.png";

  @override
  void initState() {
    context.read<WeatherBloc>().add(FetchWeather(appData.read('position')));
    super.initState();
  }

  @override
  void dispose() {
    isToday.dispose();
    areTempInF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        decoration: canvaDecoration(),
        child: Align(
          // In order to align widgets in center under listview
          heightFactor: 1.0,
          child: Center(
            child: BlocBuilder<WeatherBloc, WeatherBlocState>(
              builder: (context, state) {
                log("state: $state");
                if (state is WeatherBlocLoading) {
                  // Display loading indicator while fetching weather data
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is WeatherBlocFailure) {
                  // Display error message when weather data fetching fails
                  return Center(
                    child: Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (state is WeatherBlocSuccess) {
                  log("state.forecastWeatherInfo ${state.forecastWeatherInfo}");
                  ForecastWeatherInfo forecastWeatherInfo =
                      state.forecastWeatherInfo;

                  // Extract Location & Current Weather Info Data From Model
                  Location loc = forecastWeatherInfo.location ?? Location();
                  Current current = forecastWeatherInfo.current ?? Current();

                  // Primary Weather Icon
                  final String currentImgUrl;
                  if (current.condition?.icon != null) {
                    String originalUrl = "https:${current.condition!.icon}";
                    currentImgUrl =
                        originalUrl.replaceFirst("64x64", "128x128");
                  } else {
                    currentImgUrl = defaultWeatherImage;
                  }

                  // Forecast Extraction
                  final Forecastday todayForecast =
                      forecastWeatherInfo.forecast?.forecastday!.first ??
                          Forecastday();

                  String? maxTempTodayInC =
                      (todayForecast.day?.maxtempC != null)
                          ? todayForecast.day!.maxtempC?.toString()
                          : "0";

                  String? minTempTodayInC =
                      (todayForecast.day?.mintempC != null)
                          ? todayForecast.day?.mintempC.toString()
                          : "0";
                  Forecastday();

                  String? maxTempTodayInF =
                      (todayForecast.day?.maxtempF != null)
                          ? todayForecast.day!.maxtempF?.toString()
                          : "0";

                  String? minTempTodayInF =
                      (todayForecast.day?.mintempF != null)
                          ? todayForecast.day?.mintempF.toString()
                          : "0";

                  final List<Hour?> todaysForcastConditions =
                      todayForecast.hour!.map((e) => e).toList();

                  // Next Day's Forecast Extractionfinal
                  List<Forecastday> nextDaysForcast = forecastWeatherInfo
                          .forecast?.forecastday
                          ?.skip(1)
                          .toList() ??
                      [];

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      UIHelper.verticalSpaceMedium,
                      // Switch to change from Degree C to Farenhite
                      FadeIn(
                        duration: const Duration(milliseconds: 800),
                        child: _buildSwitchPanel(),
                      ),

                      // City Location with a slight bounce effect
                      BounceInDown(
                        duration: const Duration(milliseconds: 1000),
                        child: _buildCityText(loc),
                      ),
                      UIHelper.verticalSpaceMedium,

                      // Current Location Icon & Text - Slide up with bounce
                      SlideInUp(
                        duration: const Duration(milliseconds: 800),
                        child: _currentLocWithIcon(),
                      ),

                      // Current Weather Image & Degree Text - Smooth fade and scale up
                      ZoomIn(
                        duration: const Duration(milliseconds: 900),
                        child: _buildPrimaryWeatherIndicator(
                          currentImgUrl,
                          current,
                        ),
                      ),

                      // Weather Condition & High/Low Temp - Slide with subtle bounce
                      SlideInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: _buildWeatherConditionWithHighAndLowTemp(
                          current,
                          maxTempTodayInC,
                          minTempTodayInC,
                          maxTempTodayInF,
                          minTempTodayInF,
                        ),
                      ),
                      UIHelper.verticalSpaceMediumLarge,

                      // Today & Next Day's Buttons - Fade in smoothly
                      FadeIn(
                        duration: const Duration(milliseconds: 800),
                        child: _buildActionBtnPanel(),
                      ),
                      UIHelper.verticalSpaceMediumLarge,

                      // Forecast Panels with different animations for Today & Next Days
                      ValueListenableBuilder(
                        valueListenable: isToday,
                        builder: (context, today, child) {
                          return today
                              ? FadeInUp(
                                  duration: const Duration(milliseconds: 700),
                                  child: _buildTodayPanel(
                                    todaysForcastConditions,
                                    todayForecast,
                                  ),
                                )
                              : SlideInUp(
                                  duration: const Duration(milliseconds: 700),
                                  child: _buildNextDaysPanel(nextDaysForcast),
                                );
                        },
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSwitchPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DegreeIndicator(prefixText: "C"),
        UIHelper.horizontalSpaceSmall,
        CustomSwitch(
          hasSwitchOn: areTempInF.value,
          onChanged: (p0) {
            areTempInF.value = p0;
          },
        ),
        UIHelper.horizontalSpaceSmall,
        Text(
          "F",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        UIHelper.horizontalSpaceMedium,
      ],
    );
  }

  Text _buildCityText(Location loc) {
    return Text(
      loc.name ?? "NA",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Row _currentLocWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.icons.location.path,
            height: 20.sp, width: 20.sp),
        UIHelper.horizontalSpaceSmall,
        Text(
          'Current Location',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Circular Std',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  ValueListenableBuilder<bool> _buildActionBtnPanel() {
    return ValueListenableBuilder(
      valueListenable: isToday,
      builder: (context, today, child) {
        return Row(
          children: [
            UIHelper.horizontalSpaceSemiLarge,

            // Today Button
            Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // Turn on the today feature
                    isToday.value = true;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 18.h),
                    decoration: BoxDecoration(
                      color: today
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: _buildButtonText('Today'),
                  ),
                )),
            UIHelper.horizontalSpaceSmall,

            // Next Days Button
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  // Turn on the today feature
                  isToday.value = false;
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: 26.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: today
                        ? Colors.black.withOpacity(0.1)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: _buildButtonText('Next Days'),
                ),
              ),
            ),

            UIHelper.horizontalSpaceSemiLarge,
          ],
        );
      },
    );
  }

  SingleChildScrollView _buildWeatherConditionWithHighAndLowTemp(
    Current current,
    String? maxTempTodayInC,
    String? minTempTodayInC,
    String? maxTempTodayInF,
    String? minTempTodayInF,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Weather Condition
          Text(
            current.condition!.text ?? "NA",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Circular Std',
              fontWeight: FontWeight.w400,
            ),
          ),
          UIHelper.horizontalSpaceSmall,

          // Dividor
          Text(
            '-',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Circular Std',
              fontWeight: FontWeight.w400,
            ),
          ),
          UIHelper.horizontalSpaceSmall,

          // H
          ValueListenableBuilder(
              valueListenable: areTempInF,
              builder: (context, tempInF, child) {
                final maxTempToday =
                    tempInF ? "${maxTempTodayInF}f" : maxTempTodayInC;
                return DegreeIndicator(
                    prefixText: 'H: $maxTempToday', degreeEnabled: !tempInF);
              }),
          UIHelper.horizontalSpaceSmall,

          // L
          ValueListenableBuilder(
              valueListenable: areTempInF,
              builder: (context, tempInF, child) {
                final minTempToday =
                    tempInF ? "${minTempTodayInF}f" : minTempTodayInC;
                return DegreeIndicator(
                    prefixText: 'L: $minTempToday', degreeEnabled: !tempInF);
              }),
        ],
      ),
    );
  }

  Row _buildPrimaryWeatherIndicator(String currentImgUrl, Current current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Today's Weather Condition Image
        CustomNetworkImage(
            imageUrl: currentImgUrl, height: 130.h, width: 135.w),

        // Degree (O)
        ValueListenableBuilder(
            valueListenable: areTempInF,
            builder: (context, tempInF, child) {
              String temp = tempInF
                  ? current.tempF!.toString()
                  : current.tempC!.toString();

              String suffix = tempInF ? 'f' : '°';
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Degree Value Text
                  Text(
                    temp,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80.sp,
                      fontFamily: 'Circular Std',
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  // Degree Suffix Text
                  Padding(
                    padding: EdgeInsets.only(top: tempInF ? 24.h : 0.h),
                    child: Text(
                      suffix,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: tempInF ? 40.sp : 100.sp,
                        fontFamily: 'Circular Std',
                        fontWeight: FontWeight.w300,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }

  Widget _buildNextDaysPanel(List<Forecastday> nextForcasts) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: nextForcasts.length,
        itemBuilder: (context, index) {
          final forcast = nextForcasts[index];
          String imageUrl = "https:${forcast.day!.condition!.icon!}";

          // Remove %20 from the image URL if present
          imageUrl = imageUrl.replaceAll("%20", "");

          // Format the date to 'yyyy-MM-dd' using DateFormat
          String formattedDate = DateFormat('yyyy-MM-dd').format(forcast.date!);

          return InfoListTileCover(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomNetworkImage(
                      imageUrl: imageUrl,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    SizedBox(
                      width: 100.w,
                      child: InfoBar(
                          label: formattedDate,
                          value: forcast.day!.condition!.text!),
                    ),
                  ],
                ),
                ValueListenableBuilder(
                    valueListenable: areTempInF,
                    builder: (context, tempInF, child) {
                      String avgTemp = tempInF
                          ? "${forcast.day!.avgtempF}f"
                          : forcast.day!.avgtempC.toString();
                      return DegreeIndicator(
                          prefixText: avgTemp, degreeEnabled: !tempInF);
                    })
              ],
            ),
          );
        });
  }

  Column _buildTodayPanel(
      List<Hour?> todaysForcastConditions, Forecastday todayForecast) {
    return Column(
      children: [
        // List of Hour Weather Info Card
        _buildWeatherInfoList(todaysForcastConditions),
        UIHelper.verticalSpaceSmall,

        // Sunset & Sunrise
        InfoListTileCover(
          child: _astroInfo(todayForecast.astro ?? Astro()),
        ),

        // UV Index
        InfoListTileCover(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(Assets.icons.uv.path),
              UIHelper.horizontalSpaceMedium,
              InfoBar(
                label: 'UV Index',
                value: todayForecast.day!.uv.toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration canvaDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0.71, -0.71),
        end: Alignment(-0.71, 0.71),
        colors: [AppColors.c97ABFF, AppColors.c123597],
      ),
    );
  }

  Row _astroInfo(Astro astro) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(Assets.icons.sunFog.path),
            UIHelper.horizontalSpaceMedium,
            InfoBar(label: 'Sunset', value: astro.sunset ?? "NA"),
          ],
        ),
        InfoBar(
          label: 'Sunrise',
          value: astro.sunrise ?? "NA",
          areCrossStart: false,
        ),
      ],
    );
  }

  SizedBox _buildWeatherInfoList(List<Hour?> todaysForcastConditions) {
    return SizedBox(
      height: 190.h,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: todaysForcastConditions.length,
        itemBuilder: (context, index) {
          bool isFirst = (index == 0);
          bool isLast = (index == (todaysForcastConditions.length - 1));

          return Container(
            margin: EdgeInsets.only(
                left: isFirst ? UIHelper.kDefaulutPadding() : 0,
                right: isLast ? UIHelper.kDefaulutPadding() : 0),
            child: HourInfoCard(
              condition:
                  todaysForcastConditions[index]?.condition ?? Condition(),
              time: todaysForcastConditions[index]!.time!,
              tempInC: todaysForcastConditions[index]!.tempC!.toString(),
              tempInF: todaysForcastConditions[index]!.tempF!.toString(),
              areTempInF: areTempInF,
            ),
          );
        },
      ),
    );
  }

  Text _buildButtonText(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit
        .cover, // Default to cover to maintain the aspect ratio by default
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const Center(
        child:
            CircularProgressIndicator(), // Placeholder widget during image loading
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.error,
          size: 40.sp,
          color: Colors.red,
        ), // Error widget if image fails to load
      ),
      cacheKey: imageUrl, // Uses the image URL as the cache key
    );
  }
}

class HourInfoCard extends StatelessWidget {
  const HourInfoCard({
    super.key,
    required this.condition,
    required this.time,
    required this.tempInC,
    required this.tempInF,
    required this.areTempInF,
  });

  final Condition condition;
  final String time;
  final String tempInC;
  final String tempInF;
  final ValueNotifier<bool> areTempInF;

  @override
  Widget build(BuildContext context) {
    // Remove %20 from the URL
    String cleanedUrl = condition.icon!.replaceAll("%20", "");

    // Add https: at the beginning if not already present
    if (!cleanedUrl.startsWith("https:")) {
      cleanedUrl = "https:$cleanedUrl";
    }

    // Parse the input datetime string into a DateTime object
    DateTime dateTime = DateTime.parse(time);

    // Format the DateTime object to get the hour and period separately
    String hour =
        DateFormat('h').format(dateTime); // Get hour in 12-hour format (1-12)
    String period = DateFormat('a').format(dateTime); // Get period (AM/PM)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          MainAxisAlignment.start, // Updated to MainAxisAlignment.center
      children: [
        Container(
          width: 70.w,
          margin: EdgeInsets.only(right: 16.w, top: 6.h, bottom: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.h),
          decoration: _hourInfoDeco(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Hour
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: 'Circular Std',
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    // Styled text for the hour part (larger size)
                    TextSpan(
                      text: hour,
                      style: TextStyle(
                        fontSize: 18.sp, // Larger font size for hour
                      ),
                    ),
                    // Regular text for the period part
                    TextSpan(
                      text: period,
                      style: TextStyle(
                        fontSize: 16.sp, // Regular font size for period
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,

              // Hourly Weather Condition Image
              CustomNetworkImage(
                imageUrl: cleanedUrl,
                height: 60.h,
                width: 60.w,
              ),

              UIHelper.verticalSpaceSmall,

              ValueListenableBuilder(
                  valueListenable: areTempInF,
                  builder: (context, tempInF, child) {
                    final maxTempToday = tempInF ? "${this.tempInF}f" : tempInC;
                    return DegreeIndicator(
                        prefixText: maxTempToday, degreeEnabled: !tempInF);
                  })
            ],
          ),
        ),

        // Present Indicator
        Visibility(
          visible: false,
          child: Container(
            height: 12.h,
            width: 12.w,
            margin: EdgeInsets.only(right: 16.w, top: 8.h),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(), // Use CircleBorder for circular shape
            ),
          ),
        )
      ],
    );
  }

  ShapeDecoration _hourInfoDeco() {
    return ShapeDecoration(
      gradient: const LinearGradient(
        begin: Alignment(0.26, -0.97),
        end: Alignment(-0.26, 0.97),
        colors: [AppColors.cA2B2E7, AppColors.c5E78CE],
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Colors.white.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(50.r),
      ),
    );
  }
}
