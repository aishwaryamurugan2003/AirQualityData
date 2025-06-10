import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/air_quality_model.dart';

class AirQualityController {
  final _random = Random();
  final StreamController<List<AirQualityData>> _controller =
      StreamController.broadcast();

  List<AirQualityData> _airQualityList = [];

  Stream<List<AirQualityData>> get airQualityStream => _controller.stream;

  AirQualityController() {
    _airQualityList = _generateInitialData();
    _controller.add(_airQualityList);
    _startUpdating();
  }

  List<AirQualityData> _generateInitialData() {
    return [
      AirQualityData(
        city: "HOME",
        status: "GOOD",
        aqi: _random.nextInt(50),
        pm10: _random.nextInt(10),
        pm25: _random.nextInt(30),
        co2: _random.nextInt(50),
        backgroundColor: const Color.fromARGB(255, 108, 233, 183),
      ),
      AirQualityData(
        city: "MUMBAI, ANDHERI WEST",
        status: "MODERATE",
        aqi: _random.nextInt(100) + 50,
        pm10: _random.nextInt(100),
        pm25: _random.nextInt(150),
        co2: _random.nextInt(100),
        backgroundColor: const Color.fromARGB(255, 241, 206, 91),
      ),
      AirQualityData(
        city: "BANGALORE, KORAMANGALA",
        status: "VERY POOR",
        aqi: _random.nextInt(200) + 100,
        pm10: _random.nextInt(150),
        pm25: _random.nextInt(200),
        co2: _random.nextInt(150),
        backgroundColor: const Color.fromARGB(255, 219, 24, 7),
      ),
      AirQualityData(
        city: "DELHI, RK PURAM",
        status: "POOR",
        aqi: _random.nextInt(200) + 100,
        pm10: _random.nextInt(150),
        pm25: _random.nextInt(200),
        co2: _random.nextInt(150),
        backgroundColor: const Color.fromARGB(255, 234, 117, 59),
      ),
      AirQualityData(
        city: "GURGAON, SUSHANT LOK",
        status: "SATISFACTORY",
        aqi: _random.nextInt(100) + 50,
        pm10: _random.nextInt(100),
        pm25: _random.nextInt(150),
        co2: _random.nextInt(100),
        backgroundColor: const Color.fromARGB(255, 104, 205, 233),
      ),
      AirQualityData(
        city: "GURGAON, MG ROAD",
        status: "SERVE",
        aqi: _random.nextInt(200) + 100,
        pm10: _random.nextInt(150),
        pm25: _random.nextInt(200),
        co2: _random.nextInt(150),
        backgroundColor: const Color.fromARGB(255, 214, 31, 31),
      ),
    ];
  }

  void _startUpdating() {
    Timer.periodic(const Duration(seconds: 10), (_) {
      _airQualityList =
          _airQualityList.map((data) {
            return AirQualityData(
              city: data.city,
              status: data.status,
              aqi: _random.nextInt(500),
              pm10: _random.nextInt(150),
              pm25: _random.nextInt(100),
              co2: _random.nextInt(1000),
              backgroundColor: data.backgroundColor,
            );
          }).toList();

      _controller.add(_airQualityList);
    });
  }

  void dispose() {
    _controller.close();
  }
}
