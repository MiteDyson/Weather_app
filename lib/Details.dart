import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Import the provider from main.dart

class WeatherDetailsScreen extends StatefulWidget {
  const WeatherDetailsScreen({Key? key}) : super(key: key);

  @override
  _WeatherDetailsScreenState createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late Future<Map<String, dynamic>> _weatherDataFuture;
  late WeatherProvider _weatherProvider;

  @override
  void initState() {
    super.initState();
    _weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _weatherDataFuture = _weatherProvider.getWeatherData(
      _weatherProvider.lastSearchedCity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cityName = _weatherProvider.lastSearchedCity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather Details',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          // Button to refresh weather data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await _weatherProvider.getWeatherData(cityName);
                setState(() {
                  _weatherDataFuture = _weatherProvider.getWeatherData(
                    cityName,
                  );
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to refresh weather data'),
                  ),
                );
              }
            },
            color: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _weatherDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var weatherData = snapshot.data as Map<String, dynamic>;

            // Determine weather condition
            String weatherCondition =
                weatherData['current']['condition']['text'];

            // Determine background image based on weather condition
            String backgroundImage;
            if (weatherCondition.toLowerCase().contains('clear')) {
              backgroundImage = 'lib/images/clear.jpeg';
            } else if (weatherCondition.toLowerCase().contains(
              'partly cloudy',
            )) {
              backgroundImage = 'lib/images/partly_cloudy.jpeg';
            } else if (weatherCondition.toLowerCase().contains('cloudy')) {
              backgroundImage = 'lib/images/cloudy.jpeg';
            } else if (weatherCondition.toLowerCase().contains('rain')) {
              backgroundImage = 'lib/images/rain.jpeg';
            } else if (weatherCondition.toLowerCase().contains('drizzle')) {
              backgroundImage = 'lib/images/drizzle.jpeg';
            } else if (weatherCondition.toLowerCase().contains('showers')) {
              backgroundImage = 'lib/images/showers.jpeg';
            } else if (weatherCondition.toLowerCase().contains(
              'thunderstorms',
            )) {
              backgroundImage = 'lib/images/thunderstorms.jpeg';
            } else if (weatherCondition.toLowerCase().contains('snow')) {
              backgroundImage = 'lib/images/snow.jpeg';
            } else if (weatherCondition.toLowerCase().contains('sleet')) {
              backgroundImage = 'lib/images/sleet.jpeg';
            } else if (weatherCondition.toLowerCase().contains('hail')) {
              backgroundImage = 'lib/images/hail.jpeg';
            } else if (weatherCondition.toLowerCase().contains('humidity') ||
                weatherCondition.toLowerCase().contains('mist')) {
              backgroundImage = 'lib/images/fog.jpeg';
            } else {
              backgroundImage = 'lib/images/default.jpeg'; // Default image
            }

            return Stack(
              children: [
                // Background image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Transparent rounded box behind details
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'City: $cityName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Temperature: ${weatherData['current']['temp_c']}°C',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Weather: ${weatherData['current']['condition']['text']}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          'https:${weatherData['current']['condition']['icon']}',
                          scale: 1.5,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Humidity: ${weatherData['current']['humidity']}%',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Wind Speed: ${weatherData['current']['wind_kph']} km/h',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
