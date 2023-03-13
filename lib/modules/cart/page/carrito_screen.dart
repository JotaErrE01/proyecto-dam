import 'package:flutter/material.dart';
import 'package:myapp/modules/add_instrument/models/instrument.dart';
import 'package:myapp/modules/aut/page/login_page.dart';
import 'package:myapp/modules/view-client/page/home_screen.dart';
import 'package:myapp/modules/view-client/services/instruments_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../add_instrument/pages/new_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({Key? key}) : super(key: key);

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<InstrumentosProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 600,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            height: 80,
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage("assets/jar-loading.gif"),
                              image: NetworkImage(
                                  cartProvider.carInstruments[index].imagenUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                cartProvider.carInstruments[index].nombre,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cartProvider.deleteProduct(
                                            cartProvider.carInstruments[index]);
                                      });

                                      if (cartProvider.carInstruments.isEmpty) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                          return const HomeScreen();
                                        }), (Route<dynamic> route) => false);
                                      }
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("1"),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          cartProvider.totalAPagarProducto;
                                          cartProvider.addProductCar(
                                              cartProvider
                                                  .carInstruments[index]);
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.green[300],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          cartProvider.carInstruments[index].cantidad
                              .toString(),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          "\$ ${double.parse(cartProvider.carInstruments[index].precio) * cartProvider.carInstruments[index].cantidad}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: cartProvider.carInstruments.length,
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Valor a pagar : ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      cartProvider.totalAPagarProducto.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: const [
            Text("Confirmar compra"),
            SizedBox(width: 10),
            Icon(Icons.money_off_csred_outlined, color: Colors.white, size: 20)
          ],
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          final key = prefs.getString('key') ?? "";

          if (key.isNotEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Padding(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          "Se realizo la compra con exito!",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text("Continuar"),
                      onPressed: () {
                        cartProvider.clearCar();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }), (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }), (Route<dynamic> route) => false);
          }
        },
      ),
    );
  }
}
