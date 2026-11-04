import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../services/animal_service.dart';

class FormularioAdocao extends StatefulWidget {
  final Animal animal;

  FormularioAdocao({
    super.key,
    required this.animal,
  });

  @override
  State<FormularioAdocao> createState() => _FormularioAdocaoState();
}

class _FormularioAdocaoState extends State<FormularioAdocao> {
  final _formKey = GlobalKey<FormState>();
  final AnimalService _animalService = AnimalService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();

  bool _enviando = false;

  Future<void> _submeterFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _enviando = true;
    });

    final dadosSolicitacao = {
      'animalId': widget.animal.id,
      'nomeAnimal': widget.animal.nome,
      'nomeAdotante': _nomeController.text,
      'telefone': _telefoneController.text,
      'email': _emailController.text,
      'mensagem': _mensagemController.text,
      'data': DateTime.now().toIso8601String(),
    };

    final sucesso = await _animalService.enviarSolicitacaoAdocao(dadosSolicitacao);

    setState(() {
      _enviando = false;
    });

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Solicitação enviada com sucesso para ${widget.animal.nome}!'),
          backgroundColor: Color(0xFF568B89),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar solicitação. Tente novamente.'),
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
        title: Text('Adotar ${widget.animal.nome}'),
        backgroundColor: Color(0xFF263F50),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Formulário de Adoção',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263F50),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Preencha seus dados abaixo para iniciar o processo de adoção.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 20),

                // Campo Nome
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Seu Nome Completo',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, informe seu nome';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14),

                // Campo Telefone
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefone / WhatsApp',
                    prefixIcon: Icon(Icons.phone, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, informe seu telefone';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14),

                // Campo Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, informe seu e-mail';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14),

                // Campo Mensagem
                TextFormField(
                  controller: _mensagemController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Por que deseja adotar este pet?',
                    prefixIcon: Icon(Icons.chat, color: Color(0xFF568B89)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Botão Enviar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _enviando ? null : _submeterFormulario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF263F50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _enviando
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Enviar Solicitação',
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
        ),
      ),
    );
  }
}