import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:habit_tracker/page/welcome.dart';
import 'package:habit_tracker/provider/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Aktifkan Device Preview
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => LoginProvider()), // Tambahkan LoginProvider
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class UserProvider {
}

class PelangganProvider {
}

class BarangProvider {
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'habit_tracker',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const WelcomePage(),
    );
 
  }
}
 

 