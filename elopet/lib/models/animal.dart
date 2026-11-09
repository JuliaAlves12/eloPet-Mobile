// Classe Pai (Superclasse)
class Animal {
  final String id;
  final String nome;
  final String raca;
  final String especie;
  final String idade;
  final String porte;
  final String sexo;
  final String descricao;
  final String imagem;
  final bool disponivel;

  Animal({
    required this.id,
    required this.nome,
    required this.raca,
    required this.especie,
    required this.idade,
    required this.porte,
    required this.sexo,
    required this.descricao,
    required this.imagem,
    required this.disponivel,
  });

  // Factory inteligente: decide qual subclasse instanciar com base na espécie!
  factory Animal.fromJson(Map<String, dynamic> json) {
    final especie = json['especie']?.toString().toLowerCase() ?? '';

    if (especie == 'cachorro' || especie == 'cão') {
      return Cachorro.fromJson(json);
    } else if (especie == 'gato') {
      return Gato.fromJson(json);
    } 
    
    // Se for outra espécie (pássaro, coelho, etc), devolve a classe Pai genérica
    return Animal._fromJsonGenerico(json);
  }

  // Construtor auxiliar interno para a classe Pai
  factory Animal._fromJsonGenerico(Map<String, dynamic> json) {
    return Animal(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Sem nome',
      raca: json['raca'] ?? 'Desconhecida',
      especie: json['especie'] ?? 'Desconhecida',
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      sexo: json['sexo'] ?? '',
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? '',
      disponivel: json['disponivel'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'raca': raca,
      'especie': especie,
      'idade': idade,
      'porte': porte,
      'sexo': sexo,
      'descricao': descricao,
      'imagem': imagem,
      'disponivel': disponivel,
    };
  }
}

// Subclasse 1: Cachorro (Herda de Animal)
class Cachorro extends Animal {
  Cachorro({
    required super.id,
    required super.nome,
    required super.raca,
    required super.especie,
    required super.idade,
    required super.porte,
    required super.sexo,
    required super.descricao,
    required super.imagem,
    required super.disponivel,
  });

  factory Cachorro.fromJson(Map<String, dynamic> json) {
    return Cachorro(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Sem nome',
      raca: json['raca'] ?? 'Desconhecida',
      especie: 'Cachorro', // Força a espécie
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      sexo: json['sexo'] ?? '',
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? '',
      disponivel: json['disponivel'] ?? true,
    );
  }
}

// Subclasse 2: Gato (Herda de Animal)
class Gato extends Animal {
  Gato({
    required super.id,
    required super.nome,
    required super.raca,
    required super.especie,
    required super.idade,
    required super.porte,
    required super.sexo,
    required super.descricao,
    required super.imagem,
    required super.disponivel,
  });

  factory Gato.fromJson(Map<String, dynamic> json) {
    return Gato(
      id: json['id'] ?? '',
      nome: json['nome'] ?? 'Sem nome',
      raca: json['raca'] ?? 'Desconhecida',
      especie: 'Gato', // Força a espécie
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      sexo: json['sexo'] ?? '',
      descricao: json['descricao'] ?? '',
      imagem: json['imagem'] ?? '',
      disponivel: json['disponivel'] ?? true,
    );
  }
}