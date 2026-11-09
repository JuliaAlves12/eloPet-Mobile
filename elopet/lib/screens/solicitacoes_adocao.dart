import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Função para gerar e salvar o recibo localmente
  Future<void> _gerarReciboTxt(Map<String, dynamic> solicitacao) async {
    try {
      final nomePet = solicitacao['nomeAnimal'] ?? 'Pet';
      final nomeAdotante = solicitacao['nomeAdotante'] ?? 'Adotante';
      final dataAtual = DateTime.now().toString().substring(0, 16);

      // 1. Salva no SharedPreferences para ser exibido na tela de Perfil
      final prefs = await SharedPreferences.getInstance();
      List<String> recibosLocais = prefs.getStringList('recibos_adocao') ?? [];

      final novoRecibo = jsonEncode({
        'nomePet': nomePet,
        'nomeAdotante': nomeAdotante,
        'data': dataAtual,
        'telefone': solicitacao['telefone'] ?? 'Não informado',
        'email': solicitacao['email'] ?? 'Não informado',
      });

      recibosLocais.add(novoRecibo);
      await prefs.setStringList('recibos_adocao', recibosLocais);

      // 2. Tenta gravar o ficheiro físico .txt no dispositivo
      final conteudo = '''
        Data: $dataAtual

        Adotante: $nomeAdotante
        Telefone: ${solicitacao['telefone'] ?? 'Não informado'}
        E-mail: ${solicitacao['email'] ?? 'Não informado'}

        Pet Adotado: $nomePet
        ID do Pet: ${solicitacao['animalId'] ?? 'N/A'}
''';

      if (!kIsWeb) {
        final diretorio = await getApplicationDocumentsDirectory();
        final caminhoArquivo = '${diretorio.path}/recibo_adocao_${nomePet.replaceAll(' ', '_')}.txt';
        final arquivo = File(caminhoArquivo);
        await arquivo.writeAsString(conteudo);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Adoção concluída! Recibo disponível em "Meu Perfil".'),
            backgroundColor: Color(0xFF568B89),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar recibo: $e'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _aprovarAdocao(Map<String, dynamic> solicitacao) async {
    final String idSolicitacao = solicitacao['id'].toString();
    final String idAnimal = solicitacao['animalId'].toString();

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aprovar Adoção'),
        content: Text('Deseja aprovar a adoção para ${solicitacao['nomeAdotante']}?\n\nO pet e a solicitação serão removidos do sistema e o recibo será gerado no seu perfil.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Aprovar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      setState(() => _carregando = true);

      final sucessoSol = await _animalService.deletarSolicitacao(idSolicitacao);
      final sucessoAnim = await _animalService.deletarAnimal(idAnimal);

      if (!mounted) return;

      if (sucessoSol && sucessoAnim) {
        await _gerarReciboTxt(solicitacao);
        _buscarSolicitacoes(); 
      } else {
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar adoção. Verifique a API.'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  Future<void> _recusarAdocao(Map<String, dynamic> solicitacao) async {
    final String idSolicitacao = solicitacao['id'].toString();

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Recusar Adoção'),
        content: Text('Deseja recusar a solicitação de ${solicitacao['nomeAdotante']}?\n\nA solicitação será apagada, mas o pet continuará disponível no sistema.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            child: Text('Recusar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      setState(() => _carregando = true);

      final sucesso = await _animalService.deletarSolicitacao(idSolicitacao);

      if (!mounted) return;

      if (sucesso) {
        _buscarSolicitacoes(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitação recusada com sucesso.'),
            backgroundColor: Colors.red[400],
          ),
        );
      } else {
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao recusar a solicitação.'),
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
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFF568B89),
                                    child: Icon(Icons.pets, color: Colors.white),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Pet: ${item['nomeAnimal'] ?? 'Não informado'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF263F50),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text('Adotante: ${item['nomeAdotante'] ?? ''}'),
                              Text('Telefone: ${item['telefone'] ?? ''}'),
                              Text('E-mail: ${item['email'] ?? ''}'),
                              if (item['mensagem'] != null &&
                                  item['mensagem'].toString().isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    '"${item['mensagem']}"',
                                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700]),
                                  ),
                                ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => _recusarAdocao(item),
                                    icon: Icon(Icons.close, size: 18, color: Colors.red[400]),
                                    label: Text('Recusar', style: TextStyle(color: Colors.red[400])),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _aprovarAdocao(item),
                                    icon: Icon(Icons.check, size: 18, color: Colors.white),
                                    label: Text('Aprovar Adoção', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
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
