import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';

class CadastroAnimal extends StatefulWidget {
  CadastroAnimal({super.key});

  @override
  State<CadastroAnimal> createState() => _CadastroAnimalState();
}

class _CadastroAnimalState extends State<CadastroAnimal> {
  final _formKey = GlobalKey<FormState>();
  final AnimalService _animalService = AnimalService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();

  String _especieSelecionada = 'Cachorro';
  String _porteSelecionado = 'Médio';
  String _sexoSelecionado = 'Macho';

  bool _salvando = false;
  bool _buscandoFoto = false;

  //Busca a foto aleatória na API (Dog CEO ou Cat API)
  Future<void> _buscarFotoAutomatica() async {
    setState(() => _buscandoFoto = true);

    String urlFoto = '';
    if (_especieSelecionada == 'Cachorro') {
      urlFoto = await _animalService.meBuscarFotoCachorro();
    } else if (_especieSelecionada == 'Gato') {
      urlFoto = await _animalService.meBuscarFotoGato();
    }

    if (urlFoto.isNotEmpty) {
      _imagemController.text = urlFoto;
    }

    setState(() => _buscandoFoto = false);
  }

  //Envia os dados para a API do Render
  Future<void> _salvarAnimal() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final novoAnimal = Animal(
      id: '',
      nome: _nomeController.text.trim(),
      especie: _especieSelecionada,
      raca: _racaController.text.trim(),
      idade: _idadeController.text.trim(),
      porte: _porteSelecionado,
      sexo: _sexoSelecionado,
      descricao: _descricaoController.text.trim(),
      imagem: _imagemController.text.trim().isNotEmpty
          ? _imagemController.text.trim()
          : 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500',
      disponivel: true,
    );

    final sucesso = await _animalService.cadastrarAnimal(novoAnimal);

    setState(() => _salvando = false);

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoAnimal.nome} cadastrado com sucesso! 🐾'),
          backgroundColor: Color(0xFF568B89),
        ),
      );
      Navigator.pop(context, true); // Volta para a Home avisando que cadastrou
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar animal. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA),
      appBar: AppBar(
        title: Text('Cadastrar Novo Pet'),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome do Pet',
                    prefixIcon: Icon(Icons.pets, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Informe o nome' : null,
                ),
                SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _especieSelecionada,
                  decoration: InputDecoration(
                    labelText: 'Espécie',
                    prefixIcon: Icon(Icons.category, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: ['Cachorro', 'Gato', 'Outro']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _especieSelecionada = val);
                  },
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: _racaController,
                  decoration: InputDecoration(
                    labelText: 'Raça',
                    prefixIcon: Icon(Icons.badge, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Informe a raça' : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: _idadeController,
                  decoration: InputDecoration(
                    labelText: 'Idade (ex: 2 anos)',
                    prefixIcon: Icon(Icons.cake, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Informe a idade' : null,
                ),
                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _porteSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Porte',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Pequeno', 'Médio', 'Grande']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _porteSelecionado = val);
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sexoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Sexo',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Macho', 'Fêmea']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _sexoSelecionado = val);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _imagemController,
                        decoration: InputDecoration(
                          labelText: 'URL da Foto',
                          prefixIcon: Icon(Icons.image, color: Color(0xFF568B89)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _buscandoFoto ? null : _buscarFotoAutomatica,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF568B89),
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _buscandoFoto
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Icon(Icons.casino, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: _descricaoController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Descrição / História',
                    prefixIcon: Icon(Icons.description, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _salvarAnimal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF263F50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _salvando
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Cadastrar Pet 🐾',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}