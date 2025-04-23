import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'visita_model.dart';

class VisitaStorage {
  static const String _fileName = 'visitas.json';

  // Local onde o arquivo será salvo
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  // Salva a lista de visitas em JSON
  static Future<void> salvarVisitas(List<VisitaModel> visitas) async {
    final file = await _getFile();
    final json = visitas.map((v) => v.toJson()).toList();
    await file.writeAsString(jsonEncode(json));
  }

  // Carrega visitas do arquivo (se existir)
  static Future<List<VisitaModel>> carregarVisitas() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> json = jsonDecode(content);
        return json.map((e) => VisitaModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Adiciona uma nova visita e salva
  static Future<void> adicionarVisita(VisitaModel novaVisita) async {
    final visitas = await carregarVisitas();
    visitas.add(novaVisita);
    await salvarVisitas(visitas);
  }
}
