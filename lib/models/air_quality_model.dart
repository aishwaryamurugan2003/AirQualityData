import 'package:flutter/material.dart';
class AirQualityModel {
  double pm25;
  double pm10;
  double co;
  double no2;

  AirQualityModel({
    this.pm25 = 0.0,
    this.pm10 = 0.0,
    this.co = 0.0,
    this.no2 = 0.0,
  });

  void setParameter(String parameter, double value) {
    switch (parameter.toLowerCase()) {
      case 'pm25':
        pm25 = value;
        break;
      case 'pm10':
        pm10 = value;
        break;
      case 'co':
        co = value;
        break;
      case 'no2':
        no2 = value;
        break;
    }
  }

  @override
  String toString() {
    return 'PM2.5: $pm25, PM10: $pm10, CO: $co, NO2: $no2';
  }
}
