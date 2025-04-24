import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginOfflinePage extends StatefulWidget {
  const LoginOfflinePage({super.key});

  @override
  State<LoginOfflinePage> createState() => _LoginOfflinePageState();
}

class _LoginOfflinePageState extends State<LoginOfflinePage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  Future<void> _fazerLoginOffline() async {
    final usuarioDigitado = _usuarioController.text.trim();
    final senhaDigitada = _senhaController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final usuarioSalvo = prefs.getString('usuario');
    final senhaSalva = prefs.getString('senha');

    if (usuarioDigitado == usuarioSalvo && senhaDigitada == senhaSalva) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ou senha incorretos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Offline')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fazerLoginOffline,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
