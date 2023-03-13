import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:ui';

import '../../aut/page/login_page.dart';
import '../models/instrument.dart';
import 'new_screen.dart';

class ListInstrumentScreen extends StatefulWidget {
  const ListInstrumentScreen({Key? key}) : super(key: key);

  @override
  State<ListInstrumentScreen> createState() => _ListInstrumentScreenState();
}

class _ListInstrumentScreenState extends State<ListInstrumentScreen> {
  final List<Instrumento> _data = [];
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final snapshot = await db.collection("Instrumentos").get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _data.clear();
        for (var doc in snapshot.docs) {
          var data = doc.data();
          if (data != null) {
            _data.add(Instrumento.fromJson(data));
          }
        }
      });
      print("informacion ${_data}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.music_note,
                size: 24,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "Instrumentos",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
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
            padding: const EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 8),
                const SizedBox(height: 20),
                botonNuevoInstrumento(),
                const SizedBox(height: 20),
                // _buildPanel(),
                datos()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget datos() {
    return Container(
      height: 500, // altura definida
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_data[index].nombre ?? ''),
                Text('\$${_data[index].precio.toString()}' ?? '')
              ],
            ),
            subtitle: Text("Tipo: " + _data[index].tipo ?? ''),
            children: <Widget>[
              ListTile(
                title: _data[index].descripcion != null
                    ? Column(
                        children: [
                          SizedBox(
                            height: 200,
                            width: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(_data[index].imagenUrl),
                            ),
                          ),
                          Text(_data[index].descripcion)
                        ],
                      )
                    : Container(),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildPanel() {

  //   return ExpansionPanelList(
  //     expansionCallback: (int index, bool isExpanded) {
  //       setState(() {
  //         _data[index].isExpanded = !isExpanded;
  //       });
  //     },
  //     children: _data.map<ExpansionPanel>((Instrumento item) {
  //       return ExpansionPanel(
  //         headerBuilder: (BuildContext context, bool isExpanded) {
  //           return ListTile(
  //             title: _data != null ? Text(item.nombre) : Text(''),
  //           );
  //         },
  //         body: ListTile(
  //             title: _data != null ? Text(item.tipo) : Text(''),
  //             subtitle:
  //                 const Text('To delete this panel, tap the trash can icon'),
  //             trailing: const Icon(Icons.delete),
  //             onTap: () {
  //               // setState(() {
  //               //   _data.removeWhere(
  //               //       (Instrumento currentItem) => item == currentItem);
  //               // });
  //             }),
  //         isExpanded: item.isExpanded,
  //       );
  //     }).toList(),
  //   );
  // }

  Widget botonNuevoInstrumento() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => NewInstrumentScreen())));
        },
        style: TextButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 56, 56, 56)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Nuevo Instrumento",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
