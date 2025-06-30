class Device {
  String id;
  String name;
  String status;
  String temp;
  String humidity;
  String lastUpdated;
  String spm2;
  String spm10;
  bool isActive;

  Device({
    required this.id,
    required this.name,
    required this.status,
    required this.temp,
    required this.humidity,
    required this.lastUpdated,
    required this.spm2,
    required this.spm10,
    required this.isActive,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'inactive',
      spm2: json['spm2']?.toString() ?? '--',
      spm10: json['spm10']?.toString() ?? '--',
      temp: json['temp']?.toString() ?? '--',
      humidity: json['humidity']?.toString() ?? '--',
      lastUpdated: json['lastUpdated'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}