import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'login_offline_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final usuario = prefs.getString('usuario');
  final senha = prefs.getString('senha');

  final inicial = (usuario != null && senha != null)
      ? const LoginOfflinePage()
      : const LoginPage();

  runApp(MyApp(telaInicial: inicial));
}

class MyApp extends StatelessWidget {
  final Widget telaInicial;

  const MyApp({super.key, required this.telaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coleta de Assinaturas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: telaInicial,
    );
  }
}
