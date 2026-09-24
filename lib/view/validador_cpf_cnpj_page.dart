import 'package:flutter/material.dart';
import 'package:invertexto/service/invertexto_service.dart';

class ValidadorCpfCnpj extends StatefulWidget {
  const ValidadorCpfCnpj({super.key});
  @override
  State<ValidadorCpfCnpj> createState() => _ValidadorCpfCnpj();
}

class _ValidadorCpfCnpj extends State<ValidadorCpfCnpj> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();

  Future<Map<String, dynamic>?> _consultar() async {
    if (campo == null) return null;
    if (campo!.trim().isEmpty) {
      throw Exception('Por favor, digite um CPF ou CNPJ.');
    }
    String limpo = campo!.replaceAll(RegExp(r'[^0-9]'), '');
    if (limpo.length != 11 && limpo.length != 14) {
      throw Exception('Formato inválido. Digite 11 dígitos para CPF ou 14 para CNPJ.');
    }
    return await apiService.validaCpfCnpj(limpo);
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
                labelText: "Digite o CPF ou CNPJ",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
    if (snapshot.data != null) {
      final bool valido = snapshot.data["valid"] == true;
      dados += "Documento: ${snapshot.data["formatted"] ?? campo ?? ''}\n";
      dados += "Status: ${valido ? "Válido" : "Inválido"}";
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
