import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jeepneygo_milestone/main.dart';
import 'package:jeepneygo_milestone/models/weather_model.dart';

//  Weather Service 

class WeatherService {
  static const _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const _lat = 15.1450; // Angeles City, Pampanga
  static const _lon = 120.5887;

  static Future<WeatherModel> fetchWeather() async {
    final uri = Uri.parse(
      '$_baseUrl'
      '?latitude=$_lat'
      '&longitude=$_lon'
      '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code'
      '&wind_speed_unit=kmh'
      '&temperature_unit=celsius',
    );

    // HTTP GET request using the http package
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // JSON decoding + model parsing via fromJson
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}

//  Weather Widget 

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherModel? _weather;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final w = await WeatherService.fetchWeather();
      if (mounted) setState(() { _weather = w; _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load weather. Check your connection.';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: J.gold.withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: J.gold.withOpacity(.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('☀️', style: TextStyle(fontSize: 11)),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE WEATHER · ANGELES CITY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: J.gold,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _load,
                child: AnimatedRotation(
                  turns: _loading ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: _loading ? J.gold : J.muted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Loading State ──
          if (_loading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(J.gold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Fetching weather…',
                    style: TextStyle(
                      fontSize: 12,
                      color: J.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )

          // ── Error State ──
          else if (_error != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border(
                  left: BorderSide(color: J.gold, width: 4),
                  top: BorderSide(color: Colors.white.withOpacity(.5), width: 1.5),
                  right: BorderSide(color: Colors.white.withOpacity(.5), width: 1.5),
                  bottom: BorderSide(color: Colors.white.withOpacity(.5), width: 1.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 18, color: J.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: J.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _load,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: J.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )

          // Success State 
          else if (_weather != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _weather!.icon,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${_weather!.temperature.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: J.ink,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _weather!.condition,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: J.sub,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _weather!.commuterMessage,
                            style: const TextStyle(
                              fontSize: 12,
                              color: J.sub,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _InfoChip(
                        icon: '💧',
                        label: '${_weather!.humidity}% humidity'),
                    const SizedBox(width: 8),
                    _InfoChip(
                        icon: '💨',
                        label:
                            '${_weather!.windSpeed.toStringAsFixed(1)} km/h'),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon, label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: J.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: J.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: J.sub,
            ),
          ),
        ],
      ),
    );
  }
}