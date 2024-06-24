class Ubigeo {
  final int id;
  final String zone;
  final String district;

  Ubigeo({
    required this.id,
    required this.zone,
    required this.district,
  });

  factory Ubigeo.fromJson(Map<String, dynamic> json) {
    return Ubigeo(
      id: json['id'],
      zone: json['zone'],
      district: json['district'],
    );
  }
}
