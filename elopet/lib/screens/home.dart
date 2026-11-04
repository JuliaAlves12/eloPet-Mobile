import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import '../components/animal_card.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AnimalService _animalService = AnimalService();

  //lista para guardar os animais recebidosAPI
  List<Animal> _animais = [];

  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _buscarAnimais(); // Busca a lista assim que a tela abre
  }

  //função para buscar os dados API
  Future<void> _buscarAnimais() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final lista = await _animalService.getAnimais();
      setState(() {
        _animais = lista;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Não foi possível carregar os animais. Tente novamente!';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA),
      appBar: AppBar(
        title: Text(
          'Elo Pet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _buscarAnimais,
          ),
        ],
      ),
      body: _construirCorpo(),
    );
  }

  Widget _construirCorpo() {
    //estado carregando
    if (_carregando) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF568B89), 
        ),
      );
    }

    // estado erro de conexão
    if (_mensagemErro != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 60, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                _mensagemErro!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _buscarAnimais,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF568B89),
                ),
                child: Text('Tentar Novamente', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    // lista vazia
    if (_animais.isEmpty) {
      return Center(
        child: Text(
          'Nenhum bichinho disponível para adoção no momento.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    //sucesso
    return RefreshIndicator(
      onRefresh: _buscarAnimais,
      child: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _animais.length,
        itemBuilder: (context, index) {
          final animal = _animais[index];
          return AnimalCard(
            animal: animal,
            onTap: () {
              // Em breve abrir tela de Detalhes do Pet
            },
            onFavoritoTap: () {
              // Em breve adicionar aos Favoritos
            },
          );
        },
      ),
    );
  }
}