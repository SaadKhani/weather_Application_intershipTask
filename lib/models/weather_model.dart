class WeatherModel {
  double temperature;
  int humidity;
  final condition;
  String iconUrl;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.iconUrl,
  });

  factory WeatherModel.fromjson(Map<String, dynamic> jsonmap) {
    return WeatherModel(
      temperature: jsonmap['main']['temp'] - 273.15,
      humidity: jsonmap['main']['humidity'],
      condition: jsonmap['weather'][0]['main'],
      iconUrl:
          'https://openweathermap.org/img/wn/${jsonmap['weather'][0]['icon']}@2x.png',
    );
  }
}
