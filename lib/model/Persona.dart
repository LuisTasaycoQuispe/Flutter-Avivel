class Persona {
  final String id;
  final String document_type;
  final String document_number;
  final String names;
  final String last_names;
  final String cellphone_number;
  final String email;
  final String password;
  final String state;

  Persona({
    required this.id,
    required this.document_type,
    required this.document_number,
    required this.names,
    required this.last_names,
    required this.cellphone_number,
    required this.email,
    required this.password,
    required this.state,
  });
  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'].toString(),
      document_type: json['document_type'],
      document_number: json['document_number'].toString(),
      names: json['names'],
      last_names: json['last_names'],
      cellphone_number: json['cellphone_number'].toString(),
      email: json['email'],
      password: json['password'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'names': names,
      'last_names': last_names,
      'document_number': document_number,
      'document_type': document_type,
      'cellphone_number': cellphone_number,
      'email': email,
      'password': password,
      'state': state,
    };
  }
}


