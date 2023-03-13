import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/modules/user/models/user.dart';

var db = FirebaseFirestore.instance;

Future<void> saveUser(Usuario user) async {
  var usuario = <String, String>{
    "nombres": user.nombres,
    "correo": user.correo,
    "contrasenia": user.contrasenia,
    "rol": user.rol
  };
  await db.collection("Usuarios").add(usuario);
}

Future<String> getUser(String usuario) async {
  try {
    final querySnapshot = await db
        .collection("Usuarios")
        .where("correo", isEqualTo: usuario)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data();
      final user = Usuario.fromJson(userData);
      return user.rol;
    } else {
      throw Exception("Usuario no encontrado");
    }
  } catch (e) {
    // manejar la excepción
    print("Ocurrió un error: $e");
  }
  return 'usuario no existe';
}
