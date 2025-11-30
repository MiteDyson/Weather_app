import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart'; // Import the details screen
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class WeatherProvider with ChangeNotifier {
  // Open-Meteo does not require an API key!
  String _lastSearchedCity = '';

  String get lastSearchedCity => _lastSearchedCity;

  Future<Map<String, dynamic>> getWeatherData(String cityName) async {
    // Step 1: Geocoding (Convert City Name to Lat/Lon)
    final geoUrl =
        'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1&language=en&format=json';

    final geoResponse = await http.get(Uri.parse(geoUrl));

    if (geoResponse.statusCode != 200) {
      throw Exception('Failed to load geocoding data');
    }

    final geoData = json.decode(geoResponse.body);

    if (geoData['results'] == null || geoData['results'].isEmpty) {
      throw Exception('City not found');
    }

    final lat = geoData['results'][0]['latitude'];
    final lon = geoData['results'][0]['longitude'];
    final resolvedCityName = geoData['results'][0]['name'];

    // Step 2: Fetch Weather Data using Lat/Lon
    final weatherUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m';

    final weatherResponse = await http.get(Uri.parse(weatherUrl));

    if (weatherResponse.statusCode == 200) {
      final weatherJson = json.decode(weatherResponse.body);
      final current = weatherJson['current'];
      final code = current['weather_code'];

      // We manually construct the JSON structure to match what details.dart expects
      // This allows us to keep details.dart exactly the same!
      final mappedData = {
        'current': {
          'temp_c': current['temperature_2m'],
          'humidity': current['relative_humidity_2m'],
          'wind_kph': current['wind_speed_10m'],
          'condition': {
            'text': _getWeatherDescription(code),
            // We use a helper to get an icon URL since Open-Meteo sends just a code
            'icon': _getIconUrl(code),
          }
        }
      };

      _lastSearchedCity = resolvedCityName;
      saveLastSearchedCity(resolvedCityName);
      return mappedData;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Helper to map WMO Weather Codes to descriptive text
  // This ensures your background images in details.dart still work!
  String _getWeatherDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code == 1 || code == 2 || code == 3) return 'Partly cloudy';
    if (code == 45 || code == 48) return 'Fog';
    if (code >= 51 && code <= 55) return 'Drizzle';
    if (code >= 56 && code <= 57) return 'Freezing Drizzle';
    if (code >= 61 && code <= 65) return 'Rain';
    if (code >= 66 && code <= 67) return 'Freezing Rain';
    if (code >= 71 && code <= 77) return 'Snow';
    if (code >= 80 && code <= 82) return 'Rain showers';
    if (code >= 85 && code <= 86) return 'Snow showers';
    if (code >= 95)
      return 'Thunderstorms'; // Matches 'contains("thunderstorms")'
    return 'Unknown';
  }

  // Helper to provide an icon image based on the weather code
  // Open-Meteo doesn't provide icons, so we borrow OpenWeatherMap icons for display
  String _getIconUrl(int code) {
    // Note: details.dart prepends "https:", so we start with "//"
    String iconCode = '01d'; // default sun
    if (code == 0)
      iconCode = '01d';
    else if (code == 1)
      iconCode = '02d';
    else if (code == 2)
      iconCode = '03d';
    else if (code == 3)
      iconCode = '04d';
    else if (code == 45 || code == 48)
      iconCode = '50d';
    else if (code >= 51 && code <= 67)
      iconCode = '09d'; // Rain/Drizzle
    else if (code >= 71 && code <= 77)
      iconCode = '13d'; // Snow
    else if (code >= 80 && code <= 82)
      iconCode = '09d'; // Showers
    else if (code >= 85 && code <= 86)
      iconCode = '13d'; // Snow showers
    else if (code >= 95) iconCode = '11d'; // Thunder

    return '//openweathermap.org/img/wn/$iconCode@2x.png';
  }

  Future<void> saveLastSearchedCity(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCity', cityName);
    notifyListeners();
  }

  Future<void> loadLastSearchedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastSearchedCity = prefs.getString('lastCity') ?? '';
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _cityController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Input field for city name
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _cityController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter city name',
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Button to get weather
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () async {
                    if (_cityController.text.isEmpty) return;

                    // Show loading indicator or handle loading state if desired
                    try {
                      await weatherProvider
                          .getWeatherData(_cityController.text);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeatherDetailsScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                e.toString().replaceAll('Exception: ', '')),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Get Weather'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
