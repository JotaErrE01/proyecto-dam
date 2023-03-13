import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/instrument_service.dart';
import 'list_screen.dart';

class NewInstrumentScreen extends StatefulWidget {
  const NewInstrumentScreen({super.key});
  @override
  State<NewInstrumentScreen> createState() => _NewInstrument();
}

class _NewInstrument extends State<NewInstrumentScreen> {
  File? imagen_to_upload;
  late String selectedValue = "Seleccione un tipo";
  var instrumento = <String, String>{
    "nombre": "",
    "tipo": "",
    "imagenUrl": "",
    "precio": "",
    "descripcion": "",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 50, // Ajusta la altura de la barra
          backgroundColor: Colors.blue, // Cambia el color de fondo
          title: Padding(
            padding: const EdgeInsets.only(right: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.music_note, size: 24, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  "Nuevo Instrumento",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          )),
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://img.freepik.com/free-vector/blue-fluid-background-frame_53876-99019.jpg?w=360&t=st=1678499310~exp=1678499910~hmac=72739efa3a38b35ca231b342a427bfbb75af91fdd1508fd1ad132cda9d045ec9"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          child: ListView(children: [
            imagen(context),
            botonImagen(context),
            const SizedBox(
              height: 15,
            ),
            nombreInstrumento(),
            const SizedBox(
              height: 20,
            ),
            tipoInstrumento(),
            descripcionInstrumento(),
            precioInstrumento(),
            const SizedBox(
              height: 25,
            ),
            botonGuardar(),
            const SizedBox(
              height: 12,
            ),
            botonCancelar(context),
          ]),
        ),
      ),
    );
  }

  File? baseImage;

  Future<void> chooseImage() async {
    var choosedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      baseImage = File(choosedimage!.path);
    });
  }

  void _resetValues() {
    setState(() {
      selectedValue = "Seleccione un tipo";
      baseImage = null;
      instrumento = <String, String>{
        "nombre": "",
        "tipo": "",
        "imagenUrl": "",
        "precio": "",
        "descripcion": "",
      };
    });
  }

  Widget imagen(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: double.infinity,
        height: (screenWidth - 80.0) * 2.0 / 4.0,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: image());
  }

  Widget image() {
    if (imagen_to_upload != null)
      return Image.file(imagen_to_upload!);
    else
      return Image.network(
          'https://cdn-icons-png.flaticon.com/512/1250/1250649.png?w=740&t=st=1678504092~exp=1678504692~hmac=e2d3e9929ab1e54fce2245210de75fc94eec568fbecd22c1feeeb0e8fcbfec36');
  }

  Widget nombreInstrumento() {
    return TextFormField(
        onChanged: (value) => instrumento['nombre'] = value,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Nombre del instrumento',
            fillColor: Colors.white70));
  }

  Widget descripcionInstrumento() {
    return TextFormField(
      onChanged: (value) => instrumento['descripcion'] = value,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Descripcion',
          fillColor: Colors.blue),
    );
  }

  Widget tipoInstrumento() {
    return DropdownButton<String>(
      value: selectedValue,
      items: const [
        DropdownMenuItem(
            value: "Seleccione un tipo", child: Text('Seleccione un tipo')),
        DropdownMenuItem(value: 'Cuerda', child: Text('Cuerda')),
        DropdownMenuItem(value: 'Viento madera', child: Text('Viento madera')),
        DropdownMenuItem(value: 'Viento metal', child: Text('Viento metal')),
        DropdownMenuItem(value: 'Percusión', child: Text('Percusión')),
        DropdownMenuItem(value: 'Teclado', child: Text('Teclado')),
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value!;
          instrumento['tipo'] = value;
        });
      },
      // Muestra el valor seleccionado actual
      hint: Text(selectedValue),
    );
  }

  Widget precioInstrumento() {
    return TextFormField(
      onChanged: (value) => instrumento['precio'] = value,
      decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Precio',
          fillColor: Colors.blue),
    );
  }

  Widget botonGuardar() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          if (instrumento['nombre']!.isEmpty ||
              instrumento['precio']!.isEmpty ||
              selectedValue == "Seleccione un tipo" ||
              imagen_to_upload == null) {
            // Validación de campos requeridos
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Error"),
                  content: const Text("Faltan campos requeridos"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          } else {
            var db = FirebaseFirestore.instance;
            instrumento['imagenUrl'] = await uploadImage(imagen_to_upload!);
            db
                .collection("Instrumentos")
                .add(instrumento)
                .then((DocumentReference doc) => {
                      _resetValues(),
                      instrumento.clear(),
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(milliseconds: 2000),
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 56, 56, 56),
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
                      ))
                    });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => ListInstrumentScreen())));
          }
        },
        style: TextButton.styleFrom(backgroundColor: Colors.amber),
        child: const Text(
          "Guardar",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget botonCancelar(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => ListInstrumentScreen())));
        },
        style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
        child: const Text(
          "Cancelar",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget botonImagen(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: SizedBox(
          width: 50,
          height: 30,
          child: ElevatedButton(
            onPressed: () async {
              // chooseImage();
              final imagen = await getImage();

              setState(() {
                imagen_to_upload = File(imagen!.path);
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text("Subir Imágen"),
          ),
        ));
  }
}
