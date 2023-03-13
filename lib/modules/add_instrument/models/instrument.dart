import 'dart:convert';

class Instrumento {
  String nombre;
  String tipo;
  String imagenUrl;
  String precio;
  String descripcion;
  int cantidad;

  Instrumento(
      {required this.nombre,
      required this.tipo,
      required this.imagenUrl,
      required this.precio,
      this.descripcion = "",
      this.cantidad = 1});

  factory Instrumento.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return Instrumento(
        nombre: json['nombre'] as String,
        tipo: json['tipo'] as String,
        imagenUrl: json['imagenUrl'] as String,
        precio: (json['precio'] as String),
        descripcion: json['descripcion'] as String,
      );
    } else {
      throw Exception('Invalid JSON object');
    }
  }
}
