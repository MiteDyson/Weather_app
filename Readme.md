# Weather App

This is a simple weather application built using Flutter. It provides current weather details for any city using the WeatherAPI. The app also dynamically changes its background based on the current weather conditions.

## Features

- Search for the current weather of any city.
- Displays temperature, weather condition, humidity, and wind speed.
- Dynamic background images that change based on the weather condition.
- Saves and loads the last searched city using shared preferences.

## Screenshots

![Home Screen](https://imgur.com/gAqfmtC.png)
![Weather Details Screen](https://imgur.com/eLfQ2Cr.png)

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- An API key from WeatherAPI: [Get WeatherAPI Key](https://www.weatherapi.com/)

## Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/MiteDyson/WeatherApp.git

2. **Navigate to the project directory:**
    cd WeatherApp

3. **Get the dependencies:**
    flutter pub get

4. **Replace the placeholder API key in main.dart with your WeatherAPI key:**
    final String _apiKey = 'YOUR_API_KEY_HERE';

## Running the App
   **Run the app on an emulator or a connected device:**
        flutter run

## Usage
    Enter a city name in the input field on the home screen.
    Press the "Get Weather" button to fetch the weather details.
    The app will display the current weather details and a background image based on the weather condition.

##  Code Overview

## Main Files
    main.dart: Entry point of the app, sets up the WeatherProvider and defines the HomeScreen.

    details.dart: Defines the WeatherDetailsScreen which displays the weather information and dynamic background.

## WeatherProvider
    The WeatherProvider class is responsible for:
        Fetching weather data from WeatherAPI.
        Storing the last searched city using shared preferences.
        Providing weather data to the UI through ChangeNotifier.

## WeatherDetailsScreen
The WeatherDetailsScreen class:
    Fetches the weather data for the last searched city.
    Displays weather details like temperature, weather condition, humidity, and wind speed.
    Dynamically changes the background image based on the current weather condition.
    
## Dependencies
    flutter/material.dart: Core Flutter framework.
    provider: State management.
    shared_preferences: Persistent storage for last searched city.
    http: For making API requests.