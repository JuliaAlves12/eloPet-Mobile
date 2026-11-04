import 'package:flutter/material.dart';
import '../models/animal.dart';
import 'formulario_adocao.dart';

class DetalhesAnimal extends StatelessWidget {
  final Animal animal;

  DetalhesAnimal({
    super.key,
    required this.animal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA), 
      appBar: AppBar(
        title: Text(animal.nome),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
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
                      _construirTagInfo('Porte', animal.porte, Icons.straighten),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormularioAdocao(animal: animal),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF263F50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Quero Adotar ',
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