import 'package:flutter/material.dart';
import 'package:invertexto/service/invertexto_service.dart';

class ValidadorEmail extends StatefulWidget {
  const ValidadorEmail({super.key});
  @override
  State<ValidadorEmail> createState() => _ValidadorEmail();
}

class _ValidadorEmail extends State<ValidadorEmail> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();

  Future<Map<String, dynamic>?> _consultar() async {
    if (campo == null) return null;
    if (campo!.trim().isEmpty) {
      throw Exception('Por favor, digite um e-mail.');
    }
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(campo!.trim())) {
      throw Exception('Formato de e-mail inválido.');
    }
    return await apiService.validaEmail(campo!.trim());
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
                labelText: "Digite o e-mail",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
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
      final validFormat = snapshot.data["valid_format"] == true;
      final validMx = snapshot.data["valid_mx"] == true;
      final disposable = snapshot.data["disposable"] == true;

      dados += "E-mail: ${snapshot.data["email"] ?? campo ?? ''}\n";
      dados += "Formato: ${validFormat ? "Válido" : "Inválido"}\n";
      dados += "Servidor MX: ${validMx ? "Válido" : "Inválido"}\n";
      dados += "Descartável: ${disposable ? "Sim" : "Não"}\n";
      dados += "Status: ${validFormat && validMx && !disposable ? "E-mail Válido" : "E-mail Inválido"}";
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
