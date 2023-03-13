import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../add_instrument/models/instrument.dart';
import '../services/instruments_providers.dart';

class InstrumentCard extends StatefulWidget {
  Instrumento instrument;
  InstrumentCard({super.key, required this.instrument});

  @override
  State<InstrumentCard> createState() => _InstrumentCardState();
}

class _InstrumentCardState extends State<InstrumentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 50),
          width: double.infinity,
          height: 400,
          decoration: _cardBorders(),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [_backgroundImage(), details_product()],
          )),
    );
  }

  Container details_product() {
    final instrumentsProvider = Provider.of<InstrumentosProvider>(context);
    return Container(
      margin: const EdgeInsets.only(right: 100),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      decoration: _buildBoxDecoration(),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.instrument.nombre,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.instrument.precio,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: ElevatedButton(
              child: Image.asset(
                'assets/compra.png',
                width: 33,
              ),
              onPressed: () {
                instrumentsProvider.addProductCar(widget.instrument);
                final snackBar = SnackBar(
                  content: const Text('Agregado al carrito!'),
                  action: SnackBarAction(
                    label: 'ok!!!',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          )
        ],
      ),
    );
  }

  // ignore: sized_box_for_whitespace
  ClipRRect _backgroundImage() => ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          height: 400,
          child: FadeInImage(
            placeholder: AssetImage("assets/jar-loading.gif"),
            image: NetworkImage(
                "https://gestion.promo.ec/${widget.instrument.imagenUrl[0]}"),
            fit: BoxFit.cover,
          ),
        ),
      );

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, offset: Offset(0, 7), blurRadius: 10)
          ]);

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(25), bottomLeft: Radius.circular(25)));
}
