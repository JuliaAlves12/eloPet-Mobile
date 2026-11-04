import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';
import '../components/animal_card.dart';
import 'detalhes_animal.dart';
import 'cadastro_animal.dart';
import 'solicitacoes_adocao.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AnimalService _animalService = AnimalService();
  final TextEditingController _buscaController = TextEditingController();

  List<Animal> _todosAnimais = [];
  List<Animal> _animaisFiltrados = [];

  bool _carregando = true;
  bool _mostrarFiltros = false; 
  String? _mensagemErro;
  String _especieSelecionada = 'Todos';

  @override
  void initState() {
    super.initState();
    _buscarAnimais();
  }

  //gera a lista dinâmica de espécies com base nos animais que vieram do banco de dados
  List<String> get _especiesDisponiveis {
    final especiesUnicas = _todosAnimais.map((animal) => animal.especie).toSet().toList();
    especiesUnicas.sort();
    return ['Todos', ...especiesUnicas];
  }

  Future<void> _buscarAnimais() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final lista = await _animalService.getAnimais();
      setState(() {
        _todosAnimais = lista;
        _aplicarFiltros();
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Não foi possível carregar os animais. Tente novamente!';
        _carregando = false;
      });
    }
  }

  void _aplicarFiltros() {
    final textoBusca = _buscaController.text.toLowerCase();

    setState(() {
      _animaisFiltrados = _todosAnimais.where((animal) {
        final combinaEspecie = _especieSelecionada == 'Todos' ||
            animal.especie.toLowerCase() == _especieSelecionada.toLowerCase();
        final combinaNome = animal.nome.toLowerCase().contains(textoBusca) ||
            animal.raca.toLowerCase().contains(textoBusca);

        return combinaEspecie && combinaNome;
      }).toList();
    });
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

      // Sidebar (Drawer)
      drawer: Drawer(
        backgroundColor: Color(0xFFF5F2EA),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF263F50),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 48, color: Color(0xFFF5F2EA)),
                  SizedBox(height: 8),
                  Text(
                    'Elo Pet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Painel de Navegação',
                    style: TextStyle(
                      color: Color(0xFFB9C9BD),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Color(0xFF568B89)),
              title: Text(
                'Início',
                style: TextStyle(color: Color(0xFF263F50), fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle, color: Color(0xFF568B89)),
              title: Text(
                'Cadastrar Novo Pet',
                style: TextStyle(color: Color(0xFF263F50), fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pop(context);
                final cadastrou = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroAnimal()),
                );

                if (cadastrou == true) {
                  _buscarAnimais();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Color(0xFF568B89)),
              title: Text(
                'Solicitações de Adoção',
                style: TextStyle(color: Color(0xFF263F50), fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SolicitacoesAdocao()),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          //campo de pesquisa + botao de filtro avançado
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscaController,
                    onChanged: (val) => _aplicarFiltros(),
                    decoration: InputDecoration(
                      hintText: 'Buscar pet por nome ou raça...',
                      prefixIcon: Icon(Icons.search, color: Color(0xFF568B89)),
                      suffixIcon: _buscaController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _buscaController.clear();
                                _aplicarFiltros();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),

                Container(
                  decoration: BoxDecoration(
                    color: _mostrarFiltros ? Color(0xFF568B89) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: _mostrarFiltros ? Colors.white : Color(0xFF263F50),
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarFiltros = !_mostrarFiltros;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          //painel de Filtros
          if (_mostrarFiltros)
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: _especiesDisponiveis.map((especie) {
                    final selecionado = _especieSelecionada == especie;
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(especie),
                        selected: selecionado,
                        selectedColor: Color(0xFF568B89),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selecionado ? Colors.white : Color(0xFF263F50),
                          fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            _especieSelecionada = especie;
                            _aplicarFiltros();
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // Lista de Pets
          Expanded(
            child: _construirCorpo(),
          ),
        ],
      ),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF568B89),
        ),
      );
    }

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

    if (_animaisFiltrados.isEmpty) {
      return Center(
        child: Text(
          'Nenhum bichinho encontrado.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      );
    }

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
        itemCount: _animaisFiltrados.length,
        itemBuilder: (context, index) {
          final animal = _animaisFiltrados[index];
          return AnimalCard(
            animal: animal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesAnimal(animal: animal),
                ),
              );
            },
            onFavoritoTap: () {},
          );
        },
      ),
    );
  }
}