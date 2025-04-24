import 'dart:io';
import 'package:flutter/material.dart';
import 'visita_model.dart';

class DetalhesVisitaPage extends StatelessWidget {
  final VisitaModel visita;

  const DetalhesVisitaPage({super.key, required this.visita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Visita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (visita.fotoPath != null) ...[
              const Text(
                '📸 Foto da visita:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.file(File(visita.fotoPath!), height: 200),
              const SizedBox(height: 16),
            ],
            const Text(
              '🖊️ Assinatura:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Image.file(File(visita.imagePath), height: 200),
            const SizedBox(height: 16),
            Text('📍 Endereço: ${visita.endereco}'),
            Text('🌐 Latitude: ${visita.latitude}'),
            Text('🌐 Longitude: ${visita.longitude}'),
            const SizedBox(height: 8),
            Text('🕒 Data e Hora: ${visita.dataHora}'),
          ],
        ),
      ),
    );
  }
}
