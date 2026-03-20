// lib/models/weather_model.dart
//
// API: Open-Meteo (https://open-meteo.com/)
// Method: GET
// Endpoint:
// https://api.open-meteo.com/v1/forecast
//   ?latitude=15.1450&longitude=120.5887
//   &current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code
//   &wind_speed_unit=kmh&temperature_unit=celsius
//
// Sample JSON response:
// {
//   "current": {
//     "temperature_2m": 29.5,
//     "relative_humidity_2m": 76,
//     "wind_speed_10m": 0.4,
//     "weather_code": 2
//   }
// }

class WeatherModel {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  const WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  /// Parses the Open-Meteo JSON response into a [WeatherModel].
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  /// Human-readable condition label derived from WMO weather interpretation code.
  String get condition {
    if (weatherCode == 0) return 'Clear Sky';
    if (weatherCode <= 2) return 'Partly Cloudy';
    if (weatherCode == 3) return 'Overcast';
    if (weatherCode <= 49) return 'Foggy';
    if (weatherCode <= 59) return 'Drizzle';
    if (weatherCode <= 69) return 'Rainy';
    if (weatherCode <= 79) return 'Snowy';
    if (weatherCode <= 84) return 'Rain Showers';
    if (weatherCode <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  /// Emoji icon that matches the condition.
  String get icon {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 2) return '⛅';
    if (weatherCode == 3) return '☁️';
    if (weatherCode <= 49) return '🌫️';
    if (weatherCode <= 69) return '🌧️';
    if (weatherCode <= 79) return '❄️';
    if (weatherCode <= 84) return '🌦️';
    if (weatherCode <= 99) return '⛈️';
    return '🌡️';
  }

  /// Commuter-friendly message based on current weather.
  String get commuterMessage {
    if (weatherCode == 0 || weatherCode <= 2) return 'Great commuting weather today!';
    if (weatherCode == 3) return 'Overcast but fine for commuting.';
    if (weatherCode <= 49) return 'Foggy — ride carefully today.';
    if (weatherCode <= 69) return 'Bring an umbrella ☂️ — it\'s raining!';
    if (weatherCode <= 79) return 'Cold and icy — dress warm!';
    if (weatherCode <= 84) return 'Rain showers — expect jeepney delays.';
    return 'Thunderstorm ⚡ — consider staying indoors.';
  }
}