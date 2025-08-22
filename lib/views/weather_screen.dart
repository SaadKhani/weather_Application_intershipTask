import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weath_st/utils/colors.dart';
import 'package:weath_st/viewmodels/weather_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WeatherViewModel>(
        context,
        listen: false,
      ).fetchWeatherByCurrentLocation();
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherObj = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Weather App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xff412059),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Box
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        hintText: "Enter city name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xff412059),
                      ),
                    ),
                    onPressed: () {
                      final city = cityController.text.trim();
                      if (city.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        weatherObj.fetchWeather(city);
                      }
                    },
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Content Section
              Center(
                child: () {
                  if (weatherObj.isLoading) {
                    return const SpinKitFadingCircle(
                      color: Colors.blue,
                      size: 50,
                    );
                  } else if (weatherObj.errorMessage != null) {
                    return Text(
                      weatherObj.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  } else if (weatherObj.currenweather != null) {
                    final weather = weatherObj.currenweather!;
                    return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: weatherObj.currenweather != null
                            ? getBackgroundColor(
                                weatherObj.currenweather!.temperature,
                              )
                            : Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cityController.text.trim(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl: weather.iconUrl,
                            scale: 0.6,
                            placeholder: (context, url) =>
                                const SpinKitFadingCircle(
                                  color: Colors.blue,
                                  size: 50,
                                ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Text(
                            "${weather.temperature.toStringAsFixed(1)} °C",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weather.condition,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 10),
                          Text("Humidity: ${weather.humidity}%"),
                        ],
                      ),
                    );
                  } else {
                    return const Text(
                      "Enter a city to see weather",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    );
                  }
                }(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
