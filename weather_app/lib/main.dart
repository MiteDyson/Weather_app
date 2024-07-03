import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart'; // Import the details screen for backend
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
  final String _apiKey = '34d6b020070f448db4f163750240207'; // api key here
  String _lastSearchedCity = '';

  String get lastSearchedCity => _lastSearchedCity;

  Future<Map<String, dynamic>> getWeatherData(String cityName) async {
    final url =
        'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$cityName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _lastSearchedCity = cityName;
      saveLastSearchedCity(cityName);
      return jsonData;
    } else {
      throw Exception('Failed to load weather data');
    }
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
          style: TextStyle(
              color: Colors.white), //Color.fromARGB(255, 250, 248, 248)),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'lib/images/bg.jpg'), // Can Replace with your image path
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
                    color: Colors.white
                        .withOpacity(0.5), // Adjust opacity as neeeded
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
                      fillColor: Colors
                          .transparent, // Make sre to use transparent color
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Button to get weather
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Button background color
                  ),
                  onPressed: () async {
                    try {
                      await weatherProvider
                          .getWeatherData(_cityController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeatherDetailsScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to load weather data'),
                        ),
                      );
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
