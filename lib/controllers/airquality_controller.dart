import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/air_quality_model.dart';

class AirQualityController extends ChangeNotifier {
  static final AirQualityController _instance = AirQualityController._internal();
  factory AirQualityController() => _instance;

  AirQualityController._internal() {
    _setupDio();
    _initStations();
    _fetchAllStations();
  }

  final Dio dio = Dio();
  final String apiKey = '2624dd4a650873d959d54a681af0a425a96c079d04aa1d0f1c9943dc8760387e';

  final List<String> parameters = ['pm25', 'pm10', 'co', 'no2'];
  final Map<String, int> stationLocationIds = {

    'Velachery': 5655,
    'Alandur': 378,
    'Arumbakkam': 11581,

    'University': 13,
    'Anand vihar': 235,
    'shadipur': 2503,

    'Colaba': 2973,
    'powai': 6956,
    'Andheri': 2992,

    'Salt Lake': 3032,
    'victoria': 10633,
    'Jadavpur': 6950,
  };

  final Map<String, AirQualityModel> stationData = {};
  final Map<int, String> sensorParameterCache = {};
  bool _initialized = false;

  void _setupDio() {
    dio.options.baseUrl = 'https://api.openaq.org';
    dio.options.headers["x-api-key"] = apiKey;
    dio.options.preserveHeaderCase = true;
  }

  void _initStations() {
    for (var station in stationLocationIds.keys) {
      stationData[station] = AirQualityModel();
    }
  }

  Future<void> _fetchAllStations() async {
    if (_initialized) return;
    _initialized = true;

    for (var entry in stationLocationIds.entries) {
      final station = entry.key;
      final locId = entry.value;

      await Future.delayed(const Duration(milliseconds: 1500));
      await _fetchDataForStation(station, locId);
    }
  }

  Future<void> _fetchDataForStation(String station, int locId) async {
    try {
      final res = await dio.get('/v3/locations/$locId/latest');
      final List<dynamic> jsonList = res.data['results'] ?? [];

      String? latestDateTimeLocal;

      for (var json in jsonList) {
        // You can define AirQualityModel.fromJson(json) to return proper model
        final int? sensorId = json['sensorsId'];
        final double? value = (json['value'] is num) ? json['value'].toDouble() : null;

        String? parameter = json['parameter'];
        parameter ??= await _getParameterFromSensor(sensorId);

        if (json['datetime'] != null && json['datetime']['local'] != null && latestDateTimeLocal == null) {
          latestDateTimeLocal = json['datetime']['local'];
        }

        if (sensorId != null && value != null && parameter != null) {
          if (parameters.contains(parameter)) {
            stationData[station]?.setParameter(parameter, value);
            debugPrint('$station -> $parameter: $value');
          }
        }
      }

      if (latestDateTimeLocal != null) {
        stationData[station]?.latestDateTime = latestDateTimeLocal;
      }

      notifyListeners();
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        debugPrint('Rate limit hit for $station (429). Retrying after delay...');
        await Future.delayed(Duration(seconds: 5));
        await _fetchDataForStation(station, locId);
      } else {
        debugPrint('Dio error fetching $station: ${e.message}');
      }
    } catch (e) {
      debugPrint('General error fetching $station: $e');
    }
  }


  Future<String?> _getParameterFromSensor(int? sensorId) async {
    if (sensorId == null) return null;

    if (sensorParameterCache.containsKey(sensorId)) {
      return sensorParameterCache[sensorId];
    }

    try {
      final res = await dio.get('/v3/sensors/$sensorId');
      final List<dynamic> results = res.data['results'] ?? [];
      if (results.isNotEmpty) {
        final param = results[0]['parameter'];
        final name = param != null ? param['name'] : null;
        if (name != null) {
          sensorParameterCache[sensorId] = name;
        }
        return name;
      }
    } catch (e) {
      debugPrint('Error fetching parameter for sensor $sensorId: $e');
    }
    return null;
  }

  AirQualityModel getDataForStation(String station) {
    return stationData[station] ?? AirQualityModel();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
