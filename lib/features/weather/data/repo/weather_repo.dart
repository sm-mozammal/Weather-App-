import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/constants/app_constants.dart';
import 'package:weather_app/features/weather/model/forecast_weather_info.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/weather_info.dart';

class WeatherRepo {
  static final WeatherRepo _singleton = WeatherRepo._internal();
  WeatherRepo._internal();

  static WeatherRepo get instance => _singleton;

  Future<WeatherInfo> getCurrentData(
      {required double lat, required double lon}) async {
    try {
      // Handle API Key Retrieval
      final apiKey = dotenv.env[KKeyWeatherApi];
      if (apiKey == null) {
        ToastUtil.showShortToast('API Key not found');
        throw Exception('API Key not found');
      }

      Response response = await getHttp(Endpoints.getTempDataByLatLon(
          lat: lat, lon: lon, apiKey: apiKey, aqiEnabled: false));
      if (response.statusCode == 200) {
        WeatherInfo jsonData = WeatherInfo.fromJson(response.data);
        return jsonData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<ForecastWeatherInfo> getForecastData(
      {required double lat, required double lon}) async {
    try {
      // Handle API Key Retrieval
      final apiKey = dotenv.env[KKeyWeatherApi];
      if (apiKey == null) {
        ToastUtil.showShortToast('API Key not found');
        throw Exception('API Key not found');
      }

      Response response = await getHttp(Endpoints.getForecastDataByLatLon(
          lat: lat,
          lon: lon,
          days: 4,
          apiKey: apiKey,
          aqiEnabled: false,
          alertsEnabled: false));
      if (response.statusCode == 200) {
        ForecastWeatherInfo jsonData =
            ForecastWeatherInfo.fromJson(response.data);
        return jsonData;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
