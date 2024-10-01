part of 'weather_bloc.dart';

sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

final class WeatherBlocInitial extends WeatherBlocState {}

//class foe weather loading state
final class WeatherBlocLoading extends WeatherBlocState {}

//class for weather failure state
final class WeatherBlocFailure extends WeatherBlocState {
  final String errorMessage;
  const WeatherBlocFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

//class for weather success state
final class WeatherBlocSuccess extends WeatherBlocState {
  final ForecastWeatherInfo forecastWeatherInfo;

  const WeatherBlocSuccess(this.forecastWeatherInfo);
  @override
  List<Object> get props => [forecastWeatherInfo];

  // Override toString() method to provide meaningful representation
  @override
  String toString() => 'WeatherBlocSuccess { forecastWeatherInfo: $forecastWeatherInfo }';
}
