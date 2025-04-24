import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import 'confirmacao_page.dart';
import 'visita_model.dart';
import 'visita_storage.dart';

class AssinaturaPage extends StatefulWidget {
  const AssinaturaPage({super.key});

  @override
  State<AssinaturaPage> createState() => _AssinaturaPageState();
}

class _AssinaturaPageState extends State<AssinaturaPage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  XFile? _fotoTirada;

  void _limparAssinatura() {
    _controller.clear();
  }

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final foto = await picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      setState(() {
        _fotoTirada = foto;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto tirada com sucesso!')),
      );
    }
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      Placemark place = placemarks.first;
      String endereco =
          '${place.street}, ${place.subLocality}, ${place.locality} - ${place.administrativeArea}';

      Uint8List? image = await _controller.toPngBytes();
      if (image == null || image.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assinatura vazia!')),
        );
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/assinatura_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(image);

      final visita = VisitaModel(
        imagePath: path,
        latitude: pos.latitude,
        longitude: pos.longitude,
        endereco: endereco,
        dataHora: DateTime.now(),
        fotoPath: _fotoTirada?.path, // Aqui vai a foto (se tiver)
      );

      await VisitaStorage.adicionarVisita(visita);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmacaoPage(visita: visita),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _limparAssinatura,
                child: const Text('Limpar'),
              ),
              ElevatedButton(
                onPressed: _tirarFoto,
                child: const Text('Tirar Foto'),
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
