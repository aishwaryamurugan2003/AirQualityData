import 'package:flutter/material.dart';
import 'views/home_page.dart';
import 'views/chennai_page.dart';
import 'views/delhi_page.dart';
import 'views/kolkata_page.dart';
import 'views/mumbai_page.dart';
import 'views/kaatru_device_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Quality Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/chennai',
      routes: {
        '/home': (_) => const HomePage(),
        '/chennai': (_) => const ChennaiPage(),
        '/delhi': (_) => const DelhiPage(),
        '/kolkata': (_) => const KolkataPage(),
        '/mumbai_cpcb': (_) => const MumbaiPage(),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 1) {
          final groupId = uri.pathSegments[0];

          return MaterialPageRoute(
            builder: (_) => DevicePage(
              groupId: groupId,
              groupName: groupId[0].toUpperCase() + groupId.substring(1),
            ),
          );
        }
        return null; // fallback
      },
    );
  }
}
