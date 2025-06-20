import 'package:flutter/material.dart';
import '../controllers/airquality_controller.dart';
import '../widgets/navigation_drawer.dart';
import '../models/air_quality_model.dart';

class MumbaiPage extends StatefulWidget {
  const MumbaiPage({super.key});

  @override
  State<MumbaiPage> createState() => _MumbaiPageState();
}

class _MumbaiPageState extends State<MumbaiPage> {
  final controller = AirQualityController();

  final List<String> stationNames = ['Colaba', 'powai', 'Andheri'];
  final List<Color> cardColors = [
    Color(0xFFD7B4F3),
    Color(0xFFFFD6A5),
    Color(0xFFB5F5EC),
  ];
  final List<String> emojis = ['🌊', '🎧', '🛫'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = (screenHeight - kToolbarHeight - 80) / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mumbai - Air Quality"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD6A5),
      ),
      drawer: const NavigationDrawerWidget(),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return ListView.builder(
            itemCount: stationNames.length,
            itemBuilder: (context, index) {
              final station = stationNames[index];
              final data = controller.getDataForStation(station);
              return buildCuteCard(
                station: stationNames[index],
                data: data,
                bgColor: cardColors[index],
                emoji: emojis[index],
                height: cardHeight,
              );
            },
          );
        },
      ),
    );
  }

  Widget buildCuteCard({
    required String station,
    required AirQualityModel data,
    required Color bgColor,
    required String emoji,
    required double height,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$emoji $station",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric("PM2.5", data.pm25.toInt(), Colors.deepPurple),
              _buildMetric("PM10", data.pm10.toInt(), Colors.teal),
              _buildMetric("CO", data.co.toInt(), Colors.redAccent),
              _buildMetric("NO2", data.no2.toInt(), Colors.green),
            ],
          ),
          Text(
            "🕒 Updated: ${formatDateTime(data.latestDateTime)}",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return "N/A";
    try {
      final parsed = DateTime.parse(dateTimeStr);
      return "${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}  ${parsed.day}/${parsed.month}/${parsed.year}";
    } catch (e) {
      return "Invalid";
    }
  }
}
