class VisitaModel {
  final String imagePath;
  final double latitude;
  final double longitude;
  final String endereco;
  final DateTime dataHora;
  final String? fotoPath; // NOVO CAMPO

  VisitaModel({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.endereco,
    required this.dataHora,
    this.fotoPath, // opcional
  });

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'endereco': endereco,
      'dataHora': dataHora.toIso8601String(),
      'fotoPath': fotoPath,
    };
  }

  factory VisitaModel.fromJson(Map<String, dynamic> json) {
    return VisitaModel(
      imagePath: json['imagePath'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      endereco: json['endereco'],
      dataHora: DateTime.parse(json['dataHora']),
      fotoPath: json['fotoPath'],
    );
  }
}
