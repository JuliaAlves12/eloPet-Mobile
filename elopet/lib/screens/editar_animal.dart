import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';

class EditarAnimal extends StatefulWidget {
  final Animal animal;

  EditarAnimal({super.key, required this.animal});

  @override
  State<EditarAnimal> createState() => _EditarAnimalState();
}

class _EditarAnimalState extends State<EditarAnimal> {
  final _formKey = GlobalKey<FormState>();
  final AnimalService _animalService = AnimalService();

  late TextEditingController _nomeController;
  late TextEditingController _racaController;
  late TextEditingController _idadeController;
  late TextEditingController _descricaoController;
  late TextEditingController _imagemController;

  late String _especieSelecionada;
  late String _porteSelecionado;
  late String _sexoSelecionado;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.animal.nome);
    _racaController = TextEditingController(text: widget.animal.raca);
    _idadeController = TextEditingController(text: widget.animal.idade);
    _descricaoController = TextEditingController(text: widget.animal.descricao);
    _imagemController = TextEditingController(text: widget.animal.imagem);

    _especieSelecionada = ['Cachorro', 'Gato', 'Outro'].contains(widget.animal.especie) 
        ? widget.animal.especie 
        : 'Cachorro';
    _porteSelecionado = ['Pequeno', 'Médio', 'Grande'].contains(widget.animal.porte) 
        ? widget.animal.porte 
        : 'Médio';
    _sexoSelecionado = ['Macho', 'Fêmea'].contains(widget.animal.sexo) 
        ? widget.animal.sexo 
        : 'Macho';
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final dadosAtualizados = {
      'nome': _nomeController.text.trim(),
      'especie': _especieSelecionada,
      'raca': _racaController.text.trim(),
      'idade': _idadeController.text.trim(),
      'porte': _porteSelecionado,
      'sexo': _sexoSelecionado,
      'descricao': _descricaoController.text.trim(),
      'imagem': _imagemController.text.trim(),
      'disponivel': widget.animal.disponivel,
    };

    final sucesso = await _animalService.atualizarAnimal(widget.animal.id, dadosAtualizados);

    setState(() => _salvando = false);

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados de ${widget.animal.nome} atualizados!'), backgroundColor: Color(0xFF568B89)),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar animal.'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA),
      appBar: AppBar(
        title: Text('Editar ${widget.animal.nome}'),
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
                  decoration: InputDecoration(labelText: 'Nome do Pet', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _especieSelecionada,
                  decoration: InputDecoration(labelText: 'Espécie', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  items: ['Cachorro', 'Gato', 'Outro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _especieSelecionada = v!),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _racaController,
                  decoration: InputDecoration(labelText: 'Raça', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a raça' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _idadeController,
                  decoration: InputDecoration(labelText: 'Idade', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _imagemController,
                  decoration: InputDecoration(labelText: 'URL da Imagem', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Descrição', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _salvarAlteracoes,
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF263F50)),
                    child: _salvando ? CircularProgressIndicator(color: Colors.white) : Text('Salvar Alterações', style: TextStyle(color: Colors.white, fontSize: 16)),
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