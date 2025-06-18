class AirQualityModel {
  double pm25;
  double pm10;
  double co;
  double no2;
  String? latestDateTime;

  AirQualityModel({
    this.pm25 = 0.0,
    this.pm10 = 0.0,
    this.co = 0.0,
    this.no2 = 0.0,
    this.latestDateTime,
  });

  void setParameter(String parameter, double value) {
    switch (parameter) {
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
}
