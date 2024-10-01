import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/helpers/setup_di.dart';

import '../data/repo/weather_repo.dart';
import '../model/forecast_weather_info.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>(
        (FetchWeather event, Emitter<WeatherBlocState> emit) async {
      emit(WeatherBlocLoading());
      try {
        ForecastWeatherInfo forecastWeatherInfo = await locator
            .get<WeatherRepo>()
            .getForecastData(
                lat: event.position.latitude, lon: event.position.longitude);

        emit(WeatherBlocSuccess(forecastWeatherInfo));
      } catch (e) {
        log('error massage $e');
        emit(WeatherBlocFailure("$e"));
      }
    });
  }
}
