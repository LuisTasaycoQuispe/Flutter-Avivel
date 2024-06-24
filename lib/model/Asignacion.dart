import 'package:myapp/model/Galpones.dart';
import 'package:myapp/model/Persona.dart';

class Asignacion {
  final String id;
  final String persona;
  final String sheds;
  final String fechaInicio;

  Asignacion({
    required this.id,
    required this.persona,
    required this.sheds,
    required this.fechaInicio,
  });

  factory Asignacion.fromJson(Map<String, dynamic> json) {
    return Asignacion(
      id: json['id'].toString(),
      persona: json['persona']['id'].toString(),
      sheds: json['sheds']['id'].toString(),
      fechaInicio: json['fechaInicio'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'persona': persona,
      'sheds': sheds,
      'fechaInicio': fechaInicio,
    };
  }
}