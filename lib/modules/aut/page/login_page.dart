// ignore_for_file: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/modules/add_instrument/pages/list_screen.dart';
import 'package:myapp/modules/aut/models/usuario.dart';
import 'package:myapp/modules/aut/services/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/shared/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../add_instrument/pages/new_screen.dart';
import '../../user/pages/register_user.dart';
import '../../user/services/usuarios_provider.dart';
import '../../view-client/page/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  //Controladores par ls Inputs
  final nombreController = TextEditingController();
  final contraseniaController = TextEditingController();

  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>!
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 300,
                child: Image.asset('assets/loginImage.jpg'),
              ),
              const Center(
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Color.fromARGB(255, 56, 47, 109),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El usuario es requerido';
                  }
                  return null;
                },
                //onChanged: null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: contraseniaController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña es requerida';
                  }
                  return null;
                },
                //onChanged: null,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final user = Usuario(
                    usuario: nombreController.text.trim(),
                    contrasenia: contraseniaController.text.trim(),
                  );
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: user.usuario, password: user.contrasenia);
                    String rolUsuario =
                        await getUser(nombreController.text.trim());
                    if (rolUsuario == "Cliente") {
                      Preferences.usuario = user.usuario;
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else if (rolUsuario == "Administrador") {
                      Preferences.usuario = user.usuario;
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ListInstrumentScreen()),
                      );
                    }
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 1500),
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 209, 46, 46),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: const [
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  "Usuario o contraseña incorrecto",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 95, 76, 179),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(
                height: 10,
              ),
              botonRegistrarse(),
            ],
          ),
        ),
      ),
    );
  }

  Widget botonRegistrarse() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => RegisterUserScreen())));
        },
        style: TextButton.styleFrom(backgroundColor: Colors.yellow),
        child: const Text(
          "Registrarse",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
