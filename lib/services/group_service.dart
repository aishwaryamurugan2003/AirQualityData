import 'package:dio/dio.dart';
import '../models/city_group_model.dart';
import '../models/device_model.dart';

class GroupService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://bw04.kaatru.org/';

  Future<List<CityGroup>> fetchAllGroups() async {
    final response = await _dio.get('$baseUrl/group/all');
    final List data = response.data;
    return data
        .where((item) => item['status'] == 1 && item['id'] != 'NULL')
        .map((e) => CityGroup.fromJson(e))
        .toList();
  }

  Future<List<Device>> fetchGroupDevices(String groupId) async {
    final response = await _dio.post('$baseUrl/group', data: {'id': groupId});
    final List devices = response.data['devices'];
    return devices.map((e) => Device.fromJson(e)).toList();
  }
}
