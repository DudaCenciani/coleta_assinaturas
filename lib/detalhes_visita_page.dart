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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.file(
                File(visita.imagePath),
                height: 250,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Endereço:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(visita.endereco),
            const SizedBox(height: 10),
            const Text(
              'Localização (GPS):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('Latitude: ${visita.latitude.toStringAsFixed(5)}'),
            Text('Longitude: ${visita.longitude.toStringAsFixed(5)}'),
            const SizedBox(height: 10),
            const Text(
              'Data e Hora:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${visita.dataHora.day.toString().padLeft(2, '0')}/'
              '${visita.dataHora.month.toString().padLeft(2, '0')}/'
              '${visita.dataHora.year} - '
              '${visita.dataHora.hour.toString().padLeft(2, '0')}:'
              '${visita.dataHora.minute.toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }
}
