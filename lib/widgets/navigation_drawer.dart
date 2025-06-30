import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  List<_LocationItem> kaatruLocations = [];

  @override
  void initState() {
    super.initState();
    fetchKaatruLocations();
  }

  Future<void> fetchKaatruLocations() async {
    try {
      final response = await Dio().get('https://bw04.kaatru.org/group/all');
      final data = response.data as List;

      final filtered = data.where((item) =>
      item['status'] == 1 &&
          item['id'] != null &&
          item['id'].toString().toLowerCase() != 'null');

      final items = filtered.map<_LocationItem>((item) {
        final cityName = item['id'].toString();
        final displayName = "🌍 ${capitalize(cityName)}";
        final route = "/$cityName"; // routes like /mumbai, /gurupuram etc.
        return _LocationItem(displayName, route);
      }).toList();

      setState(() {
        kaatruLocations = items;
      });
    } catch (e) {
      debugPrint("Error fetching Kaatru locations: $e");
    }
  }

  String capitalize(String text) =>
      text.isEmpty ? '' : '${text[0].toUpperCase()}${text.substring(1)}';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF7D6E0),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '📍 Locations',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(thickness: 1.2),
          const SizedBox(height: 8),
          _buildSection(
            context,
            title: 'CPCB',
            items: [
              _LocationItem('🏖️ Chennai', '/chennai'),
              _LocationItem('🕌 Delhi', '/delhi'),
              _LocationItem('🌆 Mumbai (CPCB)', '/mumbai_cpcb'),
              _LocationItem('🌉 Kolkata', '/kolkata'),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            context,
            title: 'Kaatru',
            items: kaatruLocations.isNotEmpty
                ? kaatruLocations
                : [const _LocationItem('Loading...', '')],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<_LocationItem> items}) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      children: items
          .map((item) => _buildNavItem(context, item.label, item.route))
          .toList(),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    return Card(
      color: const Color(0xFFEFF7F6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        onTap: () {
          if (route.isNotEmpty) {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          }
        },
        trailing:
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }
}

class _LocationItem {
  final String label;
  final String route;

  const _LocationItem(this.label, this.route);
}
