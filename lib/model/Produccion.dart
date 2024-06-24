class Produccion {
  final String id;
  final String javaRosado;
  final String unidadRosado;
  final String javaQuinado;
  final String unidadQuinado;
  final String javaRoto;
  final String unidadRoto;
  final String totalProduccion;
  final String asignacionId;
  final String fecha;

  Produccion({
    required this.id,
    required this.javaRosado,
    required this.unidadRosado,
    required this.javaQuinado,
    required this.unidadQuinado,
    required this.javaRoto,
    required this.unidadRoto,
    required this.totalProduccion,
    required this.asignacionId,

    required this.fecha,
  });

  factory Produccion.fromJson(Map<String, dynamic> json) {
    return Produccion(
      id: json['id'].toString(),
      javaRosado: json['unidadRosado'].toString(),
      unidadRosado: json['unidadRosado'].toString(),
      javaQuinado: json['javaQuinado'].toString(),
      unidadQuinado: json['unidadQuinado'].toString(),
      javaRoto: json['javaRoto'].toString(),
      unidadRoto: json['unidadRoto'].toString(),
      totalProduccion: json['totalProduccion'].toString(),
      fecha: json['fecha'].toString(),
      asignacionId: json['asignacion']['id'].toString(),

      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'javaRosado': javaRosado,
      'unidadRosado': unidadRosado,
      'javaQuinado': javaQuinado,
      'unidadQuinado': unidadQuinado,
      'javaRoto': javaRoto,
      'unidadRoto': unidadRoto,
      'totalProduccion': totalProduccion,
    };
  }
}
