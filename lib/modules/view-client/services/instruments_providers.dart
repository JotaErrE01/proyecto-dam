import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../add_instrument/models/instrument.dart';

class InstrumentosProvider extends ChangeNotifier {
  var db = FirebaseFirestore.instance;

  final List<Instrumento> listaInstrumentos = [];
  List<Instrumento> _carInstrumentos = [];

  bool _loaded = false;

  InstrumentosProvider() {
    print("ENTRO AL PROVIDER INSTRUMENT");
  }

  Future<void> getInstruments() async {
    listaInstrumentos.clear();
    final snapshot = await db.collection("Instrumentos").get();
    if (snapshot.docs.isNotEmpty) {
      print("Cantidad ${snapshot.docs.length}");

      for (var i = 0; i < snapshot.docs.length; i++) {
        var data = snapshot.docs[i].data();
        if (data != null) {
          listaInstrumentos.add(Instrumento.fromJson(data));
        }
      }
    }
    notifyListeners();
  }

  List<Instrumento> get carInstruments => _carInstrumentos;
  addProductCar(Instrumento p) {
    bool existProduct = false;
    if (_carInstrumentos.isEmpty) {
      _carInstrumentos.add(p);
      _totalAPagarProducto = 0;
      calcularPago(true, p);
      return;
    }
    _carInstrumentos.forEach((instru) {
      if (p.nombre == instru.nombre) {
        instru.cantidad++;
        existProduct = true;
      }
    });
    if (!existProduct) {
      _carInstrumentos.add(p);
    }
    calcularPago(true, p);
    notifyListeners();
  }

  clearCar() {
    _carInstrumentos.clear();
    notifyListeners();
  }

  deleteProduct(Instrumento product) {
    if (product.cantidad > 1) {
      _carInstrumentos.forEach((p) {
        if (p.nombre == product.nombre) {
          p.cantidad--;
        }
      });
    } else {
      calcularPago(false, product);
      _carInstrumentos.remove(product);
    }
    calcularPago(false, product);
  }

  double get totalAPagarProducto => _totalAPagarProducto;
  set totalAPagarProducto(double value) {
    _totalAPagarProducto = value;
    notifyListeners();
  }

  double _totalAPagarProducto = 0;

  calcularPago(bool aumentar, Instrumento producto) {
    for (var prod in carInstruments) {
      if (producto.nombre == prod.nombre) {
        if (aumentar) {
          _totalAPagarProducto =
              _totalAPagarProducto + double.parse(producto.precio);
        } else {
          _totalAPagarProducto =
              _totalAPagarProducto - double.parse(producto.precio);
        }
      }
    }
  }
}
