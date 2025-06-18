import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/air_quality_model.dart';

class AirQualityController extends ChangeNotifier {
  final Dio dio = Dio();
  final String apiKey =
      '2624dd4a650873d959d54a681af0a425a96c079d04aa1d0f1c9943dc8760387e';

  final List<String> cities = ['Chennai', 'Delhi', 'Mumbai', 'Kolkata'];
  final Map<String, int> cityLocationIds = {
    'Chennai': 5655,
    'Delhi': 13,
    'Mumbai': 6927,
    'Kolkata': 716,
  };

  final List<String> parameters = ['pm25', 'pm10', 'co', 'no2'];

  Map<String, AirQualityModel> cityData = {};
  Timer? _timer;

  AirQualityController() {
    dio.options.baseUrl = 'https://api.openaq.org';
    dio.options.headers["x-api-key"] = apiKey;
    dio.options.preserveHeaderCase = true;

    for (var city in cities) {
      cityData[city] = AirQualityModel();
    }

    Future.microtask(() => _init());
  }

  Future<void> _init() async {
    for (var city in cities) {
      final locId = cityLocationIds[city];
      if (locId != null) {
        await _fetchLatestWithSensor(city, locId);
      }
    }
  }

  Future<void> _fetchLatestWithSensor(String city, int locId) async {
    try {
      final res = await dio.get('/v3/locations/$locId/latest');
      final List<dynamic> results = res.data['results'] ?? [];

      String? latestDateTimeLocal;

      for (var result in results) {
        if (latestDateTimeLocal == null &&
            result['datetime'] != null &&
            result['datetime']['local'] != null) {
          latestDateTimeLocal = result['datetime']['local'];
        }

        final int? sensorId = result['sensorsId'];
        final double? value = (result['value'] is num) ? result['value'].toDouble() : null;

        print('City: $city | Sensor ID: $sensorId | Raw Value: $value');

        if (sensorId != null && value != null) {
          final String? parameter = await _getParameterFromSensor(sensorId);

          print('Mapped Parameter: $parameter');

          if (parameter != null && parameters.contains(parameter)) {
            cityData[city]?.setParameter(parameter, value);
            print('$city -> $parameter: $value');
          } else {
            print('Parameter "$parameter" not in allowed list or null');
          }
        }
      }
      if (latestDateTimeLocal != null) {
        cityData[city]?.latestDateTime = latestDateTimeLocal;
      }

      print('Fetched latest data for $city');
      notifyListeners();
    } catch (e) {
      print('Error fetching data for $city: $e');
    }
  }

  Future<String?> _getParameterFromSensor(int sensorId) async {
    try {
      final res = await dio.get('/v3/sensors/$sensorId');
      final List<dynamic> results = res.data['results'] ?? [];
      if (results.isNotEmpty) {
        final param = results[0]['parameter'];
        return param != null ? param['name'] : null;
      }
    } catch (e) {
      print('Error fetching parameter for sensor $sensorId: $e');
    }
    return null;
  }

  AirQualityModel getDataForCity(String city) => cityData[city]!;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
