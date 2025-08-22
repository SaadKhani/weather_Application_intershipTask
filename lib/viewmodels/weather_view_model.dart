import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weath_st/models/weather_model.dart';
import 'package:weath_st/services/location_services.dart';
import 'package:weath_st/services/weather_api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherApiService apiService = WeatherApiService();

  final LocationService locationService = LocationService();

  WeatherModel? currenweather;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchWeather(cityName) async {
    log("fetchcalled");
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    log('out of try');
    try {
      log('into the try');
      List<ConnectivityResult> connection = await Connectivity()
          .checkConnectivity();
      log('$connection');
      if (!connection.contains(ConnectivityResult.mobile) &&
          !connection.contains(ConnectivityResult.wifi) &&
          !connection.contains(ConnectivityResult.ethernet)) {
        log('ruuuuun');
        errorMessage =
            'No internet connection. please connect\nto a network and try again';
        currenweather = null;
        isLoading = false;
        notifyListeners();
        return;
      }
      final weather = await apiService.fetchWeather(cityName);
      currenweather = weather;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCurrentLocation() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      log('into the try');
      List<ConnectivityResult> connection = await Connectivity()
          .checkConnectivity();
      log('$connection');
      if (!connection.contains(ConnectivityResult.mobile) &&
          !connection.contains(ConnectivityResult.wifi) &&
          !connection.contains(ConnectivityResult.ethernet)) {
        log('ruuuuun');
        errorMessage =
            'No internet connection. please connect\nto a network and try again';
        currenweather = null;
        isLoading = false;
        notifyListeners();
        return;
      }

      final position = await locationService.getCurrentLocation();
      if (position == null) {
        errorMessage = "could not get locations.";
      } else {
        final weather = await apiService.fetchWeatherByLocation(
          position.latitude,
          position.longitude,
        );
        currenweather = weather;
      }
    } catch (e) {
      errorMessage = "Failed to load weather: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
