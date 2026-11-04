import 'package:flutter/rendering.dart';

class Animal {
  final String id;
  final String nome;
  final String especie;
  final String raca;
  final String idade;
  final String porte;
  final String sexo;
  final String descricao;
  final String imagem;
  final bool disponivel;

  Animal({
    required this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    required this.idade,
    required this.porte,
    required this.sexo,
    required this.descricao,
    required this.imagem,
    this.disponivel = true,
  });

  // Converte o JSON recebido da API para um Objeto Animal no Flutter
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'].toString(),
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      raca: json['raca'] ?? '',
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      sexo: json['sexo'] ?? '',
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? '',
      disponivel: json['disponivel'] ?? true,
    );
  }

// Converte o Objeto Animal para JSON para enviar no POST/PUT da API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'idade': idade,
      'porte': porte,
      'sexo': sexo,
      'descricao': descricao,
      'imagem': imagem,
      'disponivel': disponivel
    };
  }

}