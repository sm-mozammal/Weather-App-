import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/features/weather/data/repo/weather_repo.dart';
import 'package:weather_app/networks/dio/dio.dart';

final locator = GetIt.instance;
final appData = locator.get<GetStorage>();

void setupDI() {
  locator.registerSingleton<GetStorage>(GetStorage());
  locator.registerSingleton<DioSingleton>(DioSingleton.instance);
  locator.registerLazySingleton<WeatherRepo>(() => WeatherRepo.instance);
}
