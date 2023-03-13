import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/modules/aut/page/login_page.dart';
import 'package:myapp/modules/view-client/page/product_card.dart';
import 'package:myapp/modules/view-client/services/instruments_providers.dart';
import 'package:provider/provider.dart';

import '../../add_instrument/models/instrument.dart';
import '../../cart/page/carrito_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final products = <Instrumento>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<InstrumentosProvider>(context, listen: false)
          .getInstruments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<InstrumentosProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.music_note, size: 24),
            SizedBox(width: 8),
            Text(
              "Instrumentos",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: productsProvider.listaInstrumentos.length,
          itemBuilder: (BuildContext context, int index) => ProductCard(
                instrument: productsProvider.listaInstrumentos[index],
              )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.shopping_cart),
          onPressed: () {
            if (productsProvider.carInstruments.isEmpty) {
              final snackBar = SnackBar(
                content: const Text('No hay productos en el carrito!'),
                action: SnackBarAction(
                  label: 'ok!!!',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CarritoScreen()));
            }
          }),
    );
  }
}
