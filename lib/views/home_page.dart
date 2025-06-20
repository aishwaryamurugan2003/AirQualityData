import 'package:flutter/material.dart';
import '../controllers/airquality_controller.dart';
import '../models/air_quality_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AirQualityController controller;

  final List<Color> cardColors = [
    Color(0xFFB2F2E6),
    Color(0xFFFFCB27),
    Color(0xD067CD9F),
    Color(0xFF81B5FA),
  ];

  final Map<String, String> cityMessages = {
    'Chennai': 'Velachery Res CPCB',
    'Delhi': 'Technological University',
    'Mumbai': 'Colaba',
    'Kolkata': 'Rabindra Bharati University',
  };

  @override
  void initState() {
    super.initState();
    controller = AirQualityController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.map, color: Colors.black87),
                      Text(
                        "Air Quality",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Icon(Icons.add, color: Colors.black87),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.stationLocationIds.length,
                  itemBuilder: (context, index) {
                    final city = controller.stationLocationIds.keys.elementAt(index);
                    final data = controller.stationLocationIds[city]!;
                    final color = cardColors[index % cardColors.length];
                    final message = cityMessages[city] ?? 'AQI Info';
                    return buildAirQualityCard(city, data as AirQualityModel, color, message);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildAirQualityCard(String city, AirQualityModel data, Color cardColor, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            city.toUpperCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildMetric("PM2.5", data.pm25.toInt(), Colors.deepPurple),
              buildMetric("PM10", data.pm10.toInt(), Colors.teal),
              buildMetric("CO", data.co.toInt(), Colors.red),
              buildMetric("NO2", data.no2.toInt(), Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDateTime(data.latestDateTime),
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const Icon(Icons.more_vert, size: 20, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMetric(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return "No update time";
    try {
      final parsed = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final diff = now.difference(parsed);

      if (diff.inMinutes < 1) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hrs ago';

      return "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}, ${parsed.day}/${parsed.month}/${parsed.year}";
    } catch (e) {
      return "Invalid date";
    }
  }
}
