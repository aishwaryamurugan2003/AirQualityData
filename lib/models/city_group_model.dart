class CityGroup {
  final String id;
  final String name;
  final int status;

  CityGroup({required this.id, required this.name, required this.status});

  factory CityGroup.fromJson(Map<String, dynamic> json) {
    return CityGroup(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
