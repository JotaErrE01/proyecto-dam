import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/modules/aut/page/login_page.dart';
import 'package:myapp/modules/user/models/user.dart';

import '../../../main.dart';
import '../../add_instrument/pages/new_screen.dart';
import '../services/usuarios_provider.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Registro",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://img.freepik.com/free-photo/acoustic-guitar-musical-keys-white-background-flat-lay_169016-16405.jpg?w=360&t=st=1678482464~exp=1678483064~hmac=58ba891c7732e25325f3fb29d3e09c835cee3623ee877c3887777aba2b9451dd"),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Ingrese username", Icons.person_outline,
                    false, _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Ingrese su email", Icons.email_outlined,
                    false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Ingrese su password", Icons.lock_outlined,
                    true, _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Registrarme", () async {
                  if (_emailTextController.text.isNotEmpty &&
                      _userNameTextController.text.isNotEmpty &&
                      _passwordTextController.text.isNotEmpty) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text);
                      await saveUser(Usuario(
                          nombres: _userNameTextController.text,
                          correo: _emailTextController.text,
                          contrasenia: _passwordTextController.text));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 2000),
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 248, 237, 33),
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
                                  "Registro exitoso",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(milliseconds: 2000),
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
                                    "Correo ya existente",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 2000),
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
                                  "Correo no valido",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 2000),
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
                                "Llena todos los campos",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ));
                  }
                })
              ],
            ),
          ))),
    );
  }

  TextField reusableTextField(String text, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.black87.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black87,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.black45.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }

  Container firebaseUIButton(
      BuildContext context, String title, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Color.fromARGB(255, 197, 170, 71);
              }
              return Colors.amberAccent;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
      ),
    );
  }
}
