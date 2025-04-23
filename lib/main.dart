import 'package:flutter/material.dart';
import 'home_page.dart';
import 'assinatura_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coleta de Assinaturas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/assinatura': (context) => AssinaturaPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
