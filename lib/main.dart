// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'features/weather/bloc/weather_bloc.dart';
import 'features/weather/presentation/home_screen.dart';
import 'gen/colors.gen.dart';
import 'helpers/all_routes.dart';
import 'helpers/helper_methods.dart';
import 'helpers/navigation_service.dart';
import 'helpers/setup_di.dart';
import 'networks/dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Environment Variable's
  await dotenv.load(fileName: '.env');

  // Local DB (GetStorage)
  await GetStorage.init();

  // Dependency Injection
  setupDI();

  // Ensure Stable Internet Connection
  initiInternetChecker();

  // Network Call (Dio)
  DioSingleton.instance.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        showMaterialDialog(context);
      },
      child: const MobileUtillScreen(),
    );
  }
}

class MobileUtillScreen extends StatelessWidget {
  const MobileUtillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 838),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            showMaterialDialog(context);
          },
          child: MaterialApp(
            theme: ThemeData(
              primaryColor: AppColors.c97ABFF,
              useMaterial3: false,
            ),
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            onGenerateRoute: RouteGenerator.generateRoute,
            home: const WeatherInfo(),
          ),
        );
      },
    );
  }
}

class WeatherInfo extends StatelessWidget {
  const WeatherInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPosition(),
      builder: (context, AsyncSnapshot<Position> snap) {
        if (snap.hasData) {
          appData.write('position', snap.data!);
          return BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(),
            child: const HomeScreen(),
          );
        } else if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snap.error}'),
            ),
          );
        } else {
          // Return a default widget when no data or error
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

Future<Position> _getPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  // Request permission if not granted.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    // If permission is still denied, return error.
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }

  // If permission is permanently denied, return error.
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  // Permissions are granted, so get the current position.
  return await Geolocator.getCurrentPosition();
}
