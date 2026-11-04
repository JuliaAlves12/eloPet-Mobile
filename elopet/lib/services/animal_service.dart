import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/animal.dart';

class AnimalService {
  // Endereço da API 
  static const String baseUrl = 'https://elopet-api-1.onrender.com'; 

  //Procurar todos os animais disponíveis na rota /animais
  Future<List<Animal>> getAnimais() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/animais'));

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = jsonDecode(response.body);

        //Converte cada item em Animal e filtra apenas os disponíveis (disponivel == true)
        return listaJson
            .map((item) => Animal.fromJson(item))
            .where((animal) => animal.disponivel == true)
            .toList();
      } else {
        throw Exception('Erro ao carregar lista de animais');
      }
    } catch (e) {
      throw Exception('Falha de conexão com a API: $e');
    }
  }

  //API Pública 1: Procurar foto automática de Cachorro
  Future<String> meBuscarFotoCachorro() async {
    try {
      final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);
        return dados['message'];
      }
    } catch (e) {
      //Foto de reserva caso a internet falhar
    }
    return 'https://images.dog.ceo/breeds/retriever-golden/n02099601_3000.jpg';
  }

  //API Pública 2: Procurar foto automática de Gato
  Future<String> meBuscarFotoGato() async {
    try {
      final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);
        return dados[0]['url'];
      }
    } catch (e) {
      //Foto de reserva caso a internet falhar
    }
    return 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500';
  }

  //Salvar um novo animal no banco (POST na rota /animais)
  Future<bool> cadastrarAnimal(Animal animal) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/animais'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(animal.toJson()),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}