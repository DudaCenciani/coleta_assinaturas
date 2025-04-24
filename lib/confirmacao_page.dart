import 'dart:io';
import 'package:flutter/material.dart';
import 'visita_model.dart';
import 'home_page.dart';

class ConfirmacaoPage extends StatelessWidget {
  final VisitaModel visita;

  const ConfirmacaoPage({super.key, required this.visita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assinatura Coletada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Assinatura registrada com sucesso!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            if (visita.fotoPath != null) ...[
              const Text(
                '📸 Foto (opcional):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.file(File(visita.fotoPath!), height: 200),
              const SizedBox(height: 16),
            ],
            const Text(
              'Assinatura:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Image.file(File(visita.imagePath), height: 200),
            const SizedBox(height: 16),
            Text('Endereço: ${visita.endereco}'),
            Text('Latitude: ${visita.latitude}'),
            Text('Longitude: ${visita.longitude}'),
            Text('Data e Hora: ${visita.dataHora}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              },
              child: const Text('Voltar ao Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}
