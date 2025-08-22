import 'dart:convert';
import 'package:weath_st/models/weather_model.dart';
import 'package:weath_st/utils/constants.dart';
import 'package:http/http.dart' as http;

class WeatherApiService {
  Future<WeatherModel> fetchWeather(String cityname) async {
    final url = Uri.parse(baseUrl(apiKey, cityname));

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromjson(json.decode(response.body));
    } else {
      throw Exception('failed too load data');
    }
  }

  Future<WeatherModel> fetchWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=6aa8fee8268dbb2ce6d37c571e7330e6",
    );
    // "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric"
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromjson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
