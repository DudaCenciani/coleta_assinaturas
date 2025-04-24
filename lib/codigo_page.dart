import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart'; // ou sua próxima tela

class CodigoPage extends StatefulWidget {
  final String usuario;
  final String senha;
  final String telefone;
  final String verificationId;

  const CodigoPage({
    super.key,
    required this.usuario,
    required this.senha,
    required this.telefone,
    required this.verificationId,
  });

  @override
  State<CodigoPage> createState() => _CodigoPageState();
}

class _CodigoPageState extends State<CodigoPage> {
  final _codigoController = TextEditingController();
  bool _carregando = false;

  Future<void> _verificarCodigo() async {
    final codigo = _codigoController.text.trim();

    if (codigo.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código inválido')),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: codigo,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);

      // Salvando os dados localmente para login offline
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('usuario', widget.usuario);
      await prefs.setString('senha', widget.senha);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      }
    } catch (e) {
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar Código')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Digite o código enviado por SMS:'),
            const SizedBox(height: 12),
            TextField(
              controller: _codigoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Código SMS'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _carregando ? null : _verificarCodigo,
              child: _carregando
                  ? const CircularProgressIndicator()
                  : const Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}
