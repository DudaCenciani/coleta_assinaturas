import 'package:flutter/material.dart';
import 'assinatura_page.dart';
import 'detalhes_visita_page.dart';
import 'visita_model.dart';
import 'visita_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VisitaModel> visitas = [];

  @override
  void initState() {
    super.initState();
    _carregarVisitas();
  }

  Future<void> _carregarVisitas() async {
    final lista = await VisitaStorage.carregarVisitas();
    setState(() {
      visitas = lista.reversed.toList(); // Mostra as mais recentes primeiro
    });
  }

  void _navegarParaAssinatura() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AssinaturaPage()),
    );
    _carregarVisitas(); // Recarrega ao voltar
  }

  void _abrirDetalhes(VisitaModel visita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesVisitaPage(visita: visita),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Visitas')),
      body: visitas.isEmpty
          ? const Center(child: Text('Nenhuma visita registrada ainda.'))
          : ListView.builder(
              itemCount: visitas.length,
              itemBuilder: (context, index) {
                final visita = visitas[index];
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(visita.endereco),
                  subtitle: Text('${visita.dataHora}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _abrirDetalhes(visita),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaAssinatura,
        child: const Icon(Icons.add),
      ),
    );
  }
}
