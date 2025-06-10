import 'package:flutter/material.dart';

class AirQuality {
  int aqi;
  int pm10;
  int pm25;
  int co2;

  AirQuality({
    required this.aqi,
    required this.pm10,
    required this.pm25,
    required this.co2,
  });
}

class AirQualityData {
  final String city;
  final String status;
  final int aqi;
  final int pm10;
  final int pm25;
  final int co2;
  final Color backgroundColor;

  AirQualityData({
    required this.city,
    required this.status,
    required this.aqi,
    required this.pm10,
    required this.pm25,
    required this.co2,
    required this.backgroundColor,
  });
}
