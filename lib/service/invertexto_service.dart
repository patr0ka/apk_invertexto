import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class InvertextoService {
  final String _token =
      "27964|JYFut3xxuBwpoDuMc3nAiIHgrjyDNCG4";
  Future<Map<String, dynamic>> convertePorExtenso(String? valor) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/number-to-words"
        "?token=$_token&number=$valor"
        "&language=pt",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }



  Future<Map<String, dynamic>> BuscaCep(String? valor) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/cep/$valor"
        "?token=$_token",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  bool _validaCpfLocal(String cpf) {
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;
    int soma1 = 0;
    for (int i = 0; i < 9; i++) {
      soma1 += int.parse(cpf[i]) * (10 - i);
    }
    int resto1 = soma1 % 11;
    int d1 = resto1 < 2 ? 0 : 11 - resto1;
    if (int.parse(cpf[9]) != d1) return false;
    int soma2 = 0;
    for (int i = 0; i < 10; i++) {
      soma2 += int.parse(cpf[i]) * (11 - i);
    }
    int resto2 = soma2 % 11;
    int d2 = resto2 < 2 ? 0 : 11 - resto2;
    return int.parse(cpf[10]) == d2;
  }

  bool _validaCnpjLocal(String cnpj) {
    if (cnpj.length != 14) return false;
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) return false;
    List<int> pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int soma1 = 0;
    for (int i = 0; i < 12; i++) {
      soma1 += int.parse(cnpj[i]) * pesos1[i];
    }
    int resto1 = soma1 % 11;
    int d1 = resto1 < 2 ? 0 : 11 - resto1;
    if (int.parse(cnpj[12]) != d1) return false;
    List<int> pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int soma2 = 0;
    for (int i = 0; i < 13; i++) {
      soma2 += int.parse(cnpj[i]) * pesos2[i];
    }
    int resto2 = soma2 % 11;
    int d2 = resto2 < 2 ? 0 : 11 - resto2;
    return int.parse(cnpj[13]) == d2;
  }

  String _formataCpfCnpjLocal(String doc) {
    if (doc.length == 11) {
      return "${doc.substring(0, 3)}.${doc.substring(3, 6)}.${doc.substring(6, 9)}-${doc.substring(9, 11)}";
    } else if (doc.length == 14) {
      return "${doc.substring(0, 2)}.${doc.substring(2, 5)}.${doc.substring(5, 8)}/${doc.substring(8, 12)}-${doc.substring(12, 14)}";
    }
    return doc;
  }

  Future<Map<String, dynamic>> validaCpfCnpj(String? valor, {String? tipo}) async {
    try {
      String url = "https://api.invertexto.com/v1/validator?token=$_token&value=$valor";
      if (tipo != null && tipo.isNotEmpty) {
        url += "&type=$tipo";
      }
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || (data is Map && data.isEmpty)) {
          throw Exception('Resposta vazia da API.');
        }
        return Map<String, dynamic>.from(data);
      } else {
        if (valor != null && (valor.length == 11 || valor.length == 14)) {
          final bool valido = valor.length == 11 ? _validaCpfLocal(valor) : _validaCnpjLocal(valor);
          return {
            "valid": valido,
            "formatted": _formataCpfCnpjLocal(valor),
          };
        }
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        } catch (e) {
          if (e is! FormatException) rethrow;
        }
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validaEmail(String? email) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/email-validator/$email?token=$_token",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || (data is Map && data.isEmpty)) {
          throw Exception('Resposta vazia da API.');
        }
        return Map<String, dynamic>.from(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        } catch (e) {
          if (e is! FormatException) rethrow;
        }
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> converteMoeda(String? symbols) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/currency/$symbols?token=$_token",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || (data is Map && data.isEmpty)) {
          throw Exception('Resposta vazia da API.');
        }
        return Map<String, dynamic>.from(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            throw Exception(errorData['message']);
          }
        } catch (e) {
          if (e is! FormatException) rethrow;
        }
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Erro de conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }
}




