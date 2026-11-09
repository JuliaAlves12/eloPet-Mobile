import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import 'formulario_adocao.dart';
import 'perfil.dart';

class DetalhesAnimal extends StatelessWidget {
  final Animal animal;
  final AnimalService _animalService = AnimalService();

  DetalhesAnimal({
    super.key,
    required this.animal,
  });

  // Função que verifica se o utilizador está logado antes de deixar adotar
  Future<void> _tentarAdotar(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final temPerfil = prefs.getBool('temPerfil') ?? false;

    if (!context.mounted) return;

    if (!temPerfil) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você precisa criar um perfil para adotar!'),
          backgroundColor: Colors.red[400],
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormularioAdocao(animal: animal),
        ),
      );
    }
  }

  // PUT: Marca o animal como Indisponível (Adotado)
  Future<void> _marcarComoAdotado(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Adoção'),
        content: Text('Deseja marcar ${animal.nome} como já adotado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF568B89)),
            child: Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      final dadosAtualizados = animal.toJson();
      dadosAtualizados['disponivel'] = false; // Altera o estado no PUT

      final sucesso = await _animalService.atualizarAnimal(
        animal.id,
        dadosAtualizados,
      );

      if (!context.mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${animal.nome} foi marcado como adotado!')),
        );
        Navigator.pop(context, true); // Volta para a home e atualiza
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao atualizar animal.'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  // DELETE: Apaga o animal da API
  Future<void> _deletarAnimal(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apagar Pet'),
        content: Text(
          'Tem certeza que deseja apagar ${animal.nome} do sistema?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            child: Text('Apagar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      final sucesso = await _animalService.deletarAnimal(animal.id);

      if (!context.mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${animal.nome} foi removido com sucesso.')),
        );
        Navigator.pop(context, true); // Volta para a home e atualiza
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha ao apagar animal.'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA),
      appBar: AppBar(
        title: Text(animal.nome),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
        actions: [
          // Ícone PUT (Editar status)
          IconButton(
            icon: Icon(Icons.check_circle_outline),
            tooltip: 'Marcar como Adotado',
            onPressed: () => _marcarComoAdotado(context),
          ),
          // Ícone DELETE (Apagar)
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[300]),
            tooltip: 'Apagar Pet',
            onPressed: () => _deletarAnimal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              animal.imagem,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 280,
                  color: Color(0xFFB9C9BD),
                  child: Icon(
                    Icons.pets,
                    size: 80,
                    color: Color(0xFF263F50),
                  ),
                );
              },
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.nome,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263F50),
                    ),
                  ),
                  SizedBox(height: 4),

                  Text(
                    '${animal.especie} • ${animal.raca}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF568B89),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _construirTagInfo('Idade', animal.idade, Icons.cake),
                      _construirTagInfo(
                        'Porte',
                        animal.porte,
                        Icons.straighten,
                      ),
                      _construirTagInfo('Sexo', animal.sexo, Icons.wc),
                    ],
                  ),
                  SizedBox(height: 24),

                  Text(
                    'Sobre o pet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263F50),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    animal.descricao.isNotEmpty
                        ? animal.descricao
                        : 'Este bichinho está ansioso por encontrar um novo lar cheio de amor!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _tentarAdotar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF263F50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Quero Adotar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirTagInfo(String titulo, String valor, IconData icone) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFB9C9BD)),
      ),
      child: Column(
        children: [
          Icon(icone, size: 20, color: Color(0xFF568B89)),
          SizedBox(height: 4),
          Text(
            titulo,
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263F50),
            ),
          ),
        ],
      ),
    );
  }
}
