import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

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
          _buildNavItem(context, 'Chennai', '/chennai', '🏖️'),
          _buildNavItem(context, 'Delhi', '/delhi', '🕌'),
          _buildNavItem(context, 'Mumbai', '/mumbai', '🌆'),
          _buildNavItem(context, 'Kolkata', '/kolkata', '🌉'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route, String emoji) {
    return Card(
      color: const Color(0xFFEFF7F6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        leading: Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, route);
        },
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      ),
    );
  }
}
