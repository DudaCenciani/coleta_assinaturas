import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_page.dart';

class AssinaturaPage extends StatefulWidget {
  @override
  State<AssinaturaPage> createState() => _AssinaturaPageState();
}

class _AssinaturaPageState extends State<AssinaturaPage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  void _limparAssinatura() {
    _controller.clear();
  }

  Future<void> _coletarAssinaturaELocalizacao() async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de armazenamento negada!')),
        );
        return;
      }

      Position pos = await Geolocator.getCurrentPosition();
      debugPrint('Localização: ${pos.latitude}, ${pos.longitude}');

      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      Placemark place = placemarks.first;
      String endereco =
          '${place.street}, ${place.subLocality}, ${place.locality} - ${place.administrativeArea}';

      Uint8List? image = await _controller.toPngBytes();
      if (image == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Assinatura vazia!')));
        return;
      }

      final directory = await getExternalStorageDirectory();
      final path =
          '${directory!.path}/assinatura_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(image);

      DateTime dataHora = DateTime.now();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => HomePage(
                imagePath: path,
                latitude: pos.latitude,
                longitude: pos.longitude,
                endereco: endereco,
                dataHora: dataHora,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coleta de Assinaturas')),
      body: Column(
        children: [
          Expanded(
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.grey[200]!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _limparAssinatura,
                child: const Text('Limpar'),
              ),
              ElevatedButton(
                onPressed: _coletarAssinaturaELocalizacao,
                child: const Text('Coletar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
