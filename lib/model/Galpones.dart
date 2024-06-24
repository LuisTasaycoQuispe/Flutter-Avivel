class Galpones {
  final String id;
  final String capacity;
  final String lote;
  final String type;
  final String ubicacionId;
  final String fecha;

  Galpones({
    required this.id,
    required this.capacity,
    required this.lote,
    required this.type,
    required this.ubicacionId,
    required this.fecha,
  });

  factory Galpones.fromJson(Map<String, dynamic> json) {
    return Galpones(
      id: json['id'].toString(),
      capacity: json['capacity'].toString(),
      lote: json['lote'],
      type: json['type'],
      ubicacionId: json['ubicacion']['id'].toString(),
      fecha: json['fecha'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'capacity': capacity,
      'lote': lote,
      'type': type,
      'ubicacion': {'id': ubicacionId},
    };
  }
}
