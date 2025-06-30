import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../controllers/kaatru_device_controller.dart';
import '../models/device_model.dart';

class DevicePage extends StatelessWidget {
  final String groupId;
  final String groupName;

  const DevicePage({super.key, required this.groupId, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<KaatruDeviceController>(
      create: (_) =>
      KaatruDeviceController()
        ..fetchDevices(groupId),
      child: Scaffold(
        appBar: AppBar(
          title: Text("$groupName Devices"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Consumer<KaatruDeviceController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // 👇 Active / Total Devices Count Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${controller.totalDeviceCount}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Active: ${controller.activeDeviceCount}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // 👇 Search Bar
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (query) => controller.filterDevices(query),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search device by name or ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (_) => true, // Prevent lazy-loading triggers
                    child: ListView.builder(
                      cacheExtent: 1000, // Force pre-load more devices
                      itemCount: controller.devices.length,
                      itemBuilder: (context, index) {
                        return DeviceCard(
                          device: controller.devices[index],
                          groupId: groupId,
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
class DeviceCard extends StatelessWidget {
  final Device device;

  const DeviceCard({super.key, required this.device, required String groupId});

  @override
  Widget build(BuildContext context) {
    final statusColor = device.isActive ? Colors.green : Colors.amber;
    final avatarColor =
    device.isActive ? const Color(0xFFD6EEFA) : const Color(0xFFFFE0B2);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: avatarColor,
                      radius: 24,
                      child: Text(
                        device.id.substring(0, 3).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      height: 48,
                      child: DottedLine(
                        direction: Axis.vertical,
                        lineLength: double.infinity,
                        lineThickness: 2.0,
                        dashLength: 4.0,
                        dashColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, color: statusColor, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            device.isActive ? "Active" : "Inactive",
                            style: TextStyle(
                                fontSize: 14,
                                color: statusColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _metric("PM2.5", device.spm2),
                      _metric("PM10", device.spm10),
                      _metric("Temp", device.temp),
                      _metric("Humidity", device.humidity),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Last Updated at : ${device.lastUpdated}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
