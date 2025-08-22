const String apiKey = '6aa8fee8268dbb2ce6d37c571e7330e6';

String baseUrl(String apikey, String cityname) {
  return 'https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=6aa8fee8268dbb2ce6d37c571e7330e6';
}
