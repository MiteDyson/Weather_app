
# 🌤️ Weather App — Beautiful & Accurate Weather Forecasts

<div align="center">

  <img src="https://github.com/MiteDyson/Weather_app/blob/main/lib/images/icon.png" alt="Weather App Logo" width="150">  
  <br/><br/>

**A modern Flutter application to check live weather conditions powered by Open-Meteo API**

  <br/>

![Flutter](https://img.shields.io/badge/Flutter-3.2.3+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-teal.svg)
![Open-Meteo](https://img.shields.io/badge/Open--Meteo-API-orange.svg)
![Platform](https://img.shields.io/badge/Platform-Android-blueviolet.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

<br/><br/>
____
### 📲 **[Download APK](https://drive.google.com/file/d/1SiB7-7mlHcdsK6BWM8VJeKdoHbb5F0zc/view?usp=drive_link)**

</div>

---

## ✨ Key Features

* 🌍 **City-Based Weather Search** — Get live weather of any city worldwide
* 🌡️ **Live Weather Data** — Temperature, humidity, windspeed & conditions
* 🖼️ **Dynamic Backgrounds** — UI changes based on real-time weather
* 💾 **Smart Persistence** — Saves last searched city using Shared Preferences
* ⚡ **Fast & Lightweight** — Optimized API fetching for smooth performance
* 🎨 **Clean & Modern UI** — Simple, intuitive interface made with Flutter


---

## 🚀 Quick Start Guide

### ✅ Requirements

* **Flutter SDK 3.2.3+**
* **Dart 3.0+**
* **Open-Meteo API** *(No key required!)*
* **Android Studio or VS Code**

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/MiteDyson/Weather_app
cd Weather_app
```

---

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

---

### 3️⃣ Run the App

```bash
flutter run
```

---

## 📖 How It Works

1. Enter a **city name**
2. App fetches coordinates of that city
3. Open-Meteo API returns **live temperature, humidity, windspeed & conditions**
4. Background dynamically updates based on weather condition
5. Last searched city stored via **Shared Preferences**

---

## 📱 App Screenshots

<div align="center">

<table>
<tr>
<td align="center">
<img src="https://github.com/user-attachments/assets/9f168df5-ff5a-499b-89b9-4ced0c7f65c0" width="500">
<br><strong> Adaptable User Interface</strong>
</td>

<td align="center">
<img src="https://github.com/user-attachments/assets/82f8fbb6-0fbd-4476-b8a3-a093c5d7b37a" width="500">
<br><strong>🌤️ Weather Details</strong>
</td>
</tr>
</table>

</div>

---

## 🎥 Demo Video

▶️ **[Watch Demo](https://github.com/user-attachments/assets/d593b08c-8558-421c-8119-c390333a9f65)**

---

## 🔌 API Flow

| Step | Process       | Description                          |
| ---- | ------------- | ------------------------------------ |
| `1`  | City Search   | User enters city name                |
| `2`  | Geo Lookup    | API fetches latitude/longitude       |
| `3`  | Weather Fetch | Open-Meteo returns full weather data |
| `4`  | UI Update     | Background & UI update dynamically   |
| `5`  | Persistence   | City name stored for next session    |

---

## 🛠️ Tech Stack

### **Frontend**

* 🧩 Flutter
* 🎯 Dart
* 🎨 Material Design
* 🖼️ Dynamic Image Backgrounds

### **State Management**

* 🔄 ChangeNotifier
* 📦 Provider

### **Storage**

* 💾 Shared Preferences

### **API**

* 🌐 Open-Meteo Weather API
* 📡 HTTP package

---

## 🔧 Core Files Overview

### `main.dart`

* Initializes theme
* Loads WeatherProvider
* Opens HomeScreen

### `WeatherProvider`

* Fetches weather
* Stores last searched city
* Notifies UI updates

### `WeatherDetailsScreen`

* Shows all weather stats
* Applies dynamic background based on conditions

---

## 📄 License

This project is licensed under the **MIT License**.

---

<div align="center">

### ☁️ *Made with Flutter, for a cleaner view of the sky.*

**⭐ Star the repo** — it helps a lot!

</div>

---
