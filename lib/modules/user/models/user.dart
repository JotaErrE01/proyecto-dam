class Usuario {
  String nombres;
  String correo;
  String contrasenia;
  String rol;

  Usuario(
      {required this.nombres,
      required this.correo,
      required this.contrasenia,
      this.rol = "Cliente"});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombres: json['nombres'] as String,
      correo: json['correo'] as String,
      contrasenia: json['contrasenia'] as String,
      rol: json['rol'] as String,
    );
  }
}
