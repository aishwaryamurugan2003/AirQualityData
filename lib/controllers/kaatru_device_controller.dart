import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/device_model.dart';

class KaatruDeviceController extends ChangeNotifier {
  final Dio _dio = Dio();
  final Map<String, WebSocketChannel> _channels = {};

  List<Device> _allDevices = [];
  List<Device> _filteredDevices = [];
  bool isLoading = false;

  List<Device> get devices => _filteredDevices;
  int get totalDeviceCount => _allDevices.length;
  int get activeDeviceCount => _allDevices.where((d) => d.isActive).length;

  Future<void> fetchDevices(String groupId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://bw04.kaatru.org/group',
        queryParameters: {'id': groupId},
      );

      dynamic data = response.data;
      if (data is String) {
        data = json.decode(data);
      }

      if (data is Map<String, dynamic> && data['devices'] is List) {
        _allDevices = data['devices'].map<Device>((deviceId) {
          final device = Device(
            id: deviceId,
            name: deviceId,
            status: '',
            temp: '--',
            humidity: '--',
            lastUpdated: '',
            spm2: '--',
            spm10: '--',
            isActive: false,
          );

          _connectWebSocket(device); // Start WebSocket here

          return device;
        }).toList();

        _filteredDevices = List.from(_allDevices);
      } else {
        _allDevices = [];
        _filteredDevices = [];
      }
    } catch (e) {
      debugPrint('Error fetching devices: $e');
      _allDevices = [];
      _filteredDevices = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void _connectWebSocket(Device device) {
    final url = 'wss://bw06.kaatru.org/stream/prod/gur/${device.id}/sen';
    final channel = WebSocketChannel.connect(Uri.parse(url));
    _channels[device.id] = channel;

    channel.stream.listen((message) {
      try {
        final jsonData = json.decode(message);
        if (jsonData['status'] == 200 &&
            jsonData['data'] != null &&
            jsonData['data'].isNotEmpty) {
          final value = jsonData['data'][0]['value'];
          int srvTime = jsonData['data'][0]['srvtime'];
          if (srvTime < 1000000000000) srvTime *= 1000;
          final currentMillis = DateTime.now().millisecondsSinceEpoch;
          final timeDifference = currentMillis - srvTime;
          final isNowActive = timeDifference >= 0 && timeDifference <= 15000;

          final dateTime = DateTime.fromMillisecondsSinceEpoch(srvTime);
          final formattedDate =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

          _updateDevice(
            device.id,
            spm2: value['sPM2']?.toString(),
            spm10: value['sPM10']?.toString(),
            temp: value['temp']?.toString(),
            humidity: value['rh']?.toString(),
            lastUpdated: formattedDate,
            isActive: isNowActive,
          );
        }
      } catch (e) {
        debugPrint("WS decode error for ${device.id}: $e");
      }
    });
  }

  void _updateDevice(String id,
      {String? spm2,
        String? spm10,
        String? temp,
        String? humidity,
        String? lastUpdated,
        bool? isActive}) {
    final index = _allDevices.indexWhere((d) => d.id == id);
    if (index != -1) {
      final device = _allDevices[index];
      device.spm2 = spm2 ?? device.spm2;
      device.spm10 = spm10 ?? device.spm10;
      device.temp = temp ?? device.temp;
      device.humidity = humidity ?? device.humidity;
      device.lastUpdated = lastUpdated ?? device.lastUpdated;
      if (isActive != null) device.isActive = isActive;

      notifyListeners();
    }
  }

  void filterDevices(String query) {
    if (query.isEmpty) {
      _filteredDevices = List.from(_allDevices);
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredDevices = _allDevices.where((device) {
        return device.name.toLowerCase().contains(lowerQuery) ||
            device.id.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (final channel in _channels.values) {
      channel.sink.close();
    }
    super.dispose();
  }
}
