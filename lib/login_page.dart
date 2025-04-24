import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'codigo_page.dart'; // vamos criar em seguida

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneController = TextEditingController();

  String _verificando = '';
  bool _carregando = false;

  Future<void> _enviarCodigo() async {
    final telefone = _telefoneController.text.trim();

    if (telefone.isEmpty || !telefone.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira o telefone com DDI. Ex: +55...')),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: telefone,
      verificationCompleted: (credential) {}, // ignora login automático
      verificationFailed: (e) {
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.message}')),
        );
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificando = verificationId;
          _carregando = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CodigoPage(
              usuario: _usuarioController.text.trim(),
              senha: _senhaController.text.trim(),
              telefone: telefone,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro / Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Nome de usuário'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: const InputDecoration(labelText: 'Telefone (com +55)'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _carregando ? null : _enviarCodigo,
              child: _carregando
                  ? const CircularProgressIndicator()
                  : const Text('Enviar código SMS'),
            ),
          ],
        ),
      ),
    );
  }
}
