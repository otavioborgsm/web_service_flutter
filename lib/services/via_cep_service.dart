import 'package:web_service/models/result_cep.dart';
import 'package:dio/dio.dart';
var dio = Dio();

class ViaCepService {
  static Future<ResultCep> fetchCep({String? cep}) async {
    final Uri uri = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await dio.getUri(uri);
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.toString());
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}