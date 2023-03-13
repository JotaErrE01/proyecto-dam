class Usuario {
  String usuario;
  String contrasenia;
  //Credenciales
  String? key;

  Usuario({
    required this.usuario,
    required this.contrasenia,
    this.key,
  });
}
