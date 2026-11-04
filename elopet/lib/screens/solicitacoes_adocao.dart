import 'package:flutter/material.dart';
import '../services/animal_service.dart';

class SolicitacoesAdocao extends StatefulWidget {
  SolicitacoesAdocao({super.key});

  @override
  State<SolicitacoesAdocao> createState() => _SolicitacoesAdocaoState();
}

class _SolicitacoesAdocaoState extends State<SolicitacoesAdocao> {
  final AnimalService _animalService = AnimalService();
  List<dynamic> _solicitacoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarSolicitacoes();
  }

  Future<void> _buscarSolicitacoes() async {
    setState(() {
      _carregando = true;
    });

    final lista = await _animalService.getSolicitacoes();

    setState(() {
      _solicitacoes = lista;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA),
      appBar: AppBar(
        title: Text('Solicitações de Adoção'),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
      ),
      body: _carregando
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF568B89),
              ),
            )
          : _solicitacoes.isEmpty
              ? Center(
                  child: Text(
                    'Nenhuma solicitação encontrada.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _buscarSolicitacoes,
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: _solicitacoes.length,
                    itemBuilder: (context, index) {
                      final item = _solicitacoes[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF568B89),
                            child: Icon(Icons.pets, color: Colors.white),
                          ),
                          title: Text(
                            'Pet: ${item['nomeAnimal'] ?? 'Não informado'}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263F50),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Text('Adotante: ${item['nomeAdotante'] ?? ''}'),
                              Text('Telefone: ${item['telefone'] ?? ''}'),
                              Text('E-mail: ${item['email'] ?? ''}'),
                              if (item['mensagem'] != null &&
                                  item['mensagem'].toString().isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    '"${item['mensagem']}"',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}