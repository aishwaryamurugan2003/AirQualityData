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
      body: Column(
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
            child: StreamBuilder<List<AirQualityData>>(
              stream: controller.airQualityStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final dataList = snapshot.data!;

                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return buildAirQualityCard(dataList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAirQualityCard(AirQualityData data) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: data.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.calendar_month, color: Colors.white),
                    Icon(Icons.battery_full, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  data.city.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Air is ${data.status.toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: data.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildMetric("AQI", data.aqi),
                buildMetric("PM10", data.pm10),
                buildMetric("PM2.5", data.pm25),
                buildMetric("CO2", data.co2),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Updated just now",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Icon(Icons.more_vert, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMetric(String label, int value) {
    Color getColor(String label) {
      switch (label) {
        case "AQI":
          return const Color.fromARGB(255, 37, 187, 42);
        case "PM10":
          return const Color.fromARGB(255, 65, 217, 202);
        case "PM2.5":
          return const Color.fromARGB(255, 171, 120, 44);
        case "CO2":
          return const Color.fromARGB(255, 197, 119, 95);
        default:
          return Colors.black;
      }
    }

    final labelColor = getColor(label);

    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: labelColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
