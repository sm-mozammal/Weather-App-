// ignore_for_file: constant_identifier_names

const String url = String.fromEnvironment("BASE_URL");

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();

  static const String baseUrl = ("https://api.weatherapi.com");

  //backend_url
  static String getTempDataByCountry(String country, String apiKey) =>
      "/data/2.5/weather?q=$country&appid=$apiKey";
      
  static String getTempDataByLatLon({
    required double lat,
    required double lon,
    required String apiKey,
    required bool aqiEnabled,
  }) {
    String aqi = aqiEnabled ? "yes" : "no";
    return "/v1/current.json?key=$apiKey&q=$lat,$lon&aqi=$aqi";
  }

  static String getForecastDataByLatLon(
      {required double lat,
      required double lon,
      required int days,
      required String apiKey,
      required bool aqiEnabled,
      required bool alertsEnabled}) {
    String aqi = aqiEnabled ? "yes" : "no";
    String alerts = aqiEnabled ? "yes" : "no";
    return "/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=$days&aqi=$aqi&alerts=$alerts";
  }
}
