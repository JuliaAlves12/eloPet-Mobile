import 'package:elopet/models/animal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/perfil.dart'; // Importa a sua tela de perfil

class AnimalCard extends StatefulWidget {
  final Animal animal;
  final VoidCallback onTap;

  // Repare que retirámos o 'onFavoritoTap' e o 'isFavorito',
  // pois agora o próprio cartão controla isso sozinho!
  const AnimalCard({
    super.key,
    required this.animal,
    required this.onTap,
  });

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  bool _isFavorito = false;

  @override
  void initState() {
    super.initState();
    _carregarFavorito();
  }

  // Verifica na memória do celular se este pet já está salvo
  Future<void> _carregarFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    setState(() {
      // Usamos o nome do animal para identificar (pode ser o ID se o seu modelo tiver)
      _isFavorito = favoritos.contains(widget.animal.nome);
    });
  }

  // Ação que ocorre quando se clica no coraçãozinho
  Future<void> _clicouFavoritar() async {
    final prefs = await SharedPreferences.getInstance();
    final temPerfil = prefs.getBool('temPerfil') ?? false;

    // Segurança para não dar erro de tela fechada
    if (!mounted) return;

    if (!temPerfil) {
      // Se não estiver logado, avisa e manda para o Perfil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Faça login para salvar seus pets favoritos!'),
          backgroundColor: Colors.red[400],
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Perfil()),
      ).then((_) => _carregarFavorito()); // Atualiza o coração ao voltar
      return;
    }

    // Se estiver logado, adiciona ou remove dos favoritos
    List<String> favoritos = prefs.getStringList('favoritos') ?? [];
    final animalId = widget.animal.nome;

    setState(() {
      if (favoritos.contains(animalId)) {
        favoritos.remove(animalId);
        _isFavorito = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.animal.nome} foi removido.')),
        );
      } else {
        favoritos.add(animalId);
        _isFavorito = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.animal.nome} salvo nos favoritos!')),
        );
      }
    });

    // Grava as alterações no aparelho
    await prefs.setStringList('favoritos', favoritos);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.animal.imagem,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: const Color(0XFFB9C9BD),
                      child: const Icon(
                        Icons.pets,
                        size: 100,
                        color: Color(0xFF263F50),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    radius: 18,
                    child: IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _isFavorito ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorito ? Colors.red : const Color(0xFF263F50),
                      ),
                      onPressed: _clicouFavoritar, // Chama a nossa função interna!
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.animal.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263F50),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.animal.especie} • ${widget.animal.raca}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF568B89),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.animal.idade,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.straighten, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.animal.porte,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
