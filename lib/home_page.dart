import 'dart:io';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final String? endereco;
  final DateTime? dataHora;

  const HomePage({
    super.key,
    this.imagePath,
    this.latitude,
    this.longitude,
    this.endereco,
    this.dataHora,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Última Assinatura')),
      body: Center(
        child:
            imagePath != null
                ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Assinatura mais recente:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.file(File(imagePath!), height: 200),
                      const SizedBox(height: 20),
                      const Text(
                        'Localização:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Latitude: ${latitude?.toStringAsFixed(5) ?? '---'}',
                      ),
                      Text(
                        'Longitude: ${longitude?.toStringAsFixed(5) ?? '---'}',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Endereço:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          endereco ?? 'Endereço não disponível',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Data e Hora:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dataHora != null
                            ? '${dataHora!.day.toString().padLeft(2, '0')}/${dataHora!.month.toString().padLeft(2, '0')}/${dataHora!.year} - ${dataHora!.hour.toString().padLeft(2, '0')}:${dataHora!.minute.toString().padLeft(2, '0')}'
                            : 'Data não disponível',
                      ),
                    ],
                  ),
                )
                : const Text(
                  'Nenhuma assinatura coletada ainda.',
                  style: TextStyle(fontSize: 16),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/assinatura');
        },
        child: const Icon(Icons.edit),
        tooltip: 'Nova Assinatura',
      ),
    );
  }
}
