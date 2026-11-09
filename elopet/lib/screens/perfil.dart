import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _temPerfilLocal = false;
  String _nomeSalvo = '';
  String _emailSalvo = '';
  List<Map<String, dynamic>> _recibosAdocao = [];

  @override
  void initState() {
    super.initState();
    _carregarDadosLocais();
  }

  Future<void> _carregarDadosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    final listRecibos = prefs.getStringList('recibos_adocao') ?? [];

    setState(() {
      _temPerfilLocal = prefs.getBool('temPerfil') ?? false;
      _nomeSalvo = prefs.getString('nome') ?? '';
      _emailSalvo = prefs.getString('email') ?? '';
      _recibosAdocao = listRecibos
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _salvarPerfil() async {
    if (_nomeController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha nome e e-mail')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('temPerfil', true);
    await prefs.setString('nome', _nomeController.text.trim());
    await prefs.setString('email', _emailController.text.trim());

    setState(() {
      _temPerfilLocal = true;
      _nomeSalvo = _nomeController.text.trim();
      _emailSalvo = _emailController.text.trim();
    });
  }

  Future<void> _apagarPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('temPerfil');
    await prefs.remove('nome');
    await prefs.remove('email');

    setState(() {
      _temPerfilLocal = false;
      _nomeController.clear();
      _emailController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2EA),
      appBar: AppBar(
        title: Text('Meu Perfil'),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
      ),
      body: _temPerfilLocal ? _construirAbaPerfil() : _construirFormularioCadastro(),
    );
  }

  Widget _construirFormularioCadastro() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.account_circle, size: 80, color: Color(0xFF568B89)),
          SizedBox(height: 16),
          Text(
            'Crie seu perfil para salvar seus pets favoritos e agilizar adoções!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF263F50)),
          ),
          SizedBox(height: 24),
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Seu Nome',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Seu E-mail',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _salvarPerfil,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF568B89),
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Salvar Perfil', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _construirAbaPerfil() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF568B89),
                  child: Text(
                    _nomeSalvo.isNotEmpty ? _nomeSalvo[0].toUpperCase() : '?',
                    style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 12),
                Text(_nomeSalvo, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF263F50))),
                Text(_emailSalvo, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                SizedBox(height: 12),
                TextButton(
                  onPressed: _apagarPerfil,
                  child: Text('Sair da Conta', style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long, color: Color(0xFF263F50)),
                    SizedBox(width: 8),
                    Text(
                      'Meus Recibos de Adoção',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF263F50)),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                _recibosAdocao.isEmpty
                    ? Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Nenhuma adoção concluída até o momento.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _recibosAdocao.length,
                        itemBuilder: (context, index) {
                          final recibo = _recibosAdocao[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Icon(Icons.verified, color: Colors.green[700]),
                              ),
                              title: Text(
                                'Adoção: ${recibo['nomePet']}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF263F50)),
                              ),
                              subtitle: Text('Data: ${recibo['data']}'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Divider(),
                                      Text('Adotante: ${recibo['nomeAdotante']}'),
                                      Text('Telefone: ${recibo['telefone']}'),
                                      Text('E-mail: ${recibo['email']}'),
                                      SizedBox(height: 8),
                                      Text(
                                        'Status: Recibo Oficial Confirmado',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
