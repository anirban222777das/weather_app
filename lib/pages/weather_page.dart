import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('ec1474ca8066749e41a763932c27da6c');
  Weather? _weather;

  // Fetch weather data
  _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
    }
  }

  // Determine animation based on weather and temperature
  String _getAnimationAsset() {
    if (_weather == null || _weather!.description == null) {
      return 'assets/cloudy.json'; // Default animation if weather data isn't available
    }

    final description = _weather!.description!.toLowerCase();
    final temp = _weather!.temperature;

    if (description.contains('rain') || description.contains('drizzle')) {
      return 'assets/rainy.json';
    } else if (description.contains('cloud')) {
      return 'assets/cloudy.json';
    } else if (temp > 30) {
      return 'assets/sunny.json'; // Hot weather, sunny animation
    } else if (description.contains('sun')) {
      return 'assets/sunny.json'; // General sunny animation
    } else {
      return 'assets/sunnyrain.json'; // Default or mixed animation
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73C8A9), // Top gradient color
              Color(0xFF373B44), // Bottom gradient color
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City name
              Text(
                _weather?.cityName ?? "Fetching Location...",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Weather animation
              Lottie.asset(
                _getAnimationAsset(),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 10),

              // Temperature
              Text(
                _weather != null
                    ? '${_weather!.temperature.round()}°C'
                    : "Loading Temperature...",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Weather description (only show when available)
              if (_weather?.description != null)
                Text(
                  _weather!.description!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              const SizedBox(height: 30),

              // Cool Refresh Button
              GestureDetector(
                onTap: _fetchWeather,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF56CCF2), // Light blue
                        Color(0xFF2F80ED), // Dark blue
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Refresh",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
