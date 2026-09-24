import 'package:flutter/material.dart';
import 'package:invertexto/service/invertexto_service.dart';

class ConversorMoeda extends StatefulWidget {
  const ConversorMoeda({super.key});
  @override
  State<ConversorMoeda> createState() => _ConversorMoeda();
}

class _ConversorMoeda extends State<ConversorMoeda> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();

  String _codigo = "USD_BRL";
  String _nome = "Dólar";
  double _quantidade = 1.0;

  Future<Map<String, dynamic>?> _consultar() async {
    if (campo == null) return null;
    final texto = campo!.trim().toLowerCase();
    if (texto.isEmpty) {
      throw Exception('Por favor, digite o nome de uma moeda.');
    }

    double qtd = 1.0;
    final matchQtd = RegExp(r'(\d+([.,]\d+)?)').firstMatch(texto);
    if (matchQtd != null) {
      final parsed = double.tryParse(matchQtd.group(1)!.replaceAll(',', '.'));
      if (parsed != null && parsed > 0) {
        qtd = parsed;
      }
    }
    _quantidade = qtd;

    if (texto.contains('canadense') || texto.contains('cad')) {
      _codigo = 'CAD_BRL';
      _nome = 'Dólar Canadense';
    } else if (texto.contains('dolar') || texto.contains('dollar') || texto.contains('usd')) {
      _codigo = 'USD_BRL';
      _nome = 'Dólar';
    } else if (texto.contains('euro') || texto.contains('eur')) {
      _codigo = 'EUR_BRL';
      _nome = 'Euro';
    } else if (texto.contains('yen') || texto.contains('iene') || texto.contains('jpy')) {
      _codigo = 'JPY_BRL';
      _nome = 'Yen';
    } else if (texto.contains('libra') || texto.contains('gbp')) {
      _codigo = 'GBP_BRL';
      _nome = 'Libra';
    } else if (texto.contains('peso') || texto.contains('argentino') || texto.contains('ars')) {
      _codigo = 'ARS_BRL';
      _nome = 'Peso Argentino';
    } else if (RegExp(r'^[a-z]{3}_[a-z]{3}$').hasMatch(texto)) {
      _codigo = texto.toUpperCase();
      _nome = _codigo;
    } else {
      throw Exception('Moeda não encontrada. Digite: dolar, euro, yen, libra, etc.');
    }

    return await apiService.converteMoeda(_codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Digite a moeda (ex: dolar, euro, yen)",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),

            FutureBuilder(
              future: _consultar(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  case ConnectionState.none:
                    return Container();
                  default:
                    if (snapshot.hasError) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          snapshot.error.toString().replaceAll('Exception: ', ''),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Container();
                    } else {
                      return exibeResultado(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String dados = '';
    if (snapshot.data != null && snapshot.data[_codigo] != null) {
      final num preco = snapshot.data[_codigo]["price"] ?? 0;
      final double total = _quantidade * preco.toDouble();

      dados += "Moeda: $_nome para Real";
      dados += "\n";
      dados += "Cotação: 1 $_nome = R\$ ${preco.toString()}";
      if (_quantidade != 1.0) {
        dados += "\n";
        dados += "Total: $_quantidade $_nome = R\$ ${total.toStringAsFixed(2)}";
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        dados,
        style: TextStyle(color: Colors.white, fontSize: 18),
        softWrap: true,
      ),
    );
  }
}
