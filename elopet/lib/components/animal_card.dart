import 'package:elopet/models/animal.dart';
import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final Animal animal;
  final VoidCallback onTap;
  final VoidCallback? onFavoritoTap;
  final bool isFavorito;
  
  const AnimalCard({
    super.key,
    required this.animal,
    required this.onTap,
    this.onFavoritoTap,
    this.isFavorito = false,
    });

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
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Imagem do animal com botao de favorito sobreposto
            Stack(
              children: [
                Image.network(
                  animal.imagem,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, StackTrace) {
                    return Container(
                      height: 200,
                      color: Color(0XFFB9C9BD),
                      child: Icon(
                        Icons.pets,
                        size: 100,
                        color: Color(0xFF263F50),
                      ),
                    );
                  },
                ),
                if (onFavoritoTap != null)
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
                        isFavorito ? Icons.favorite : Icons.favorite_border,
                        color: isFavorito ? Colors.red: Color(0xFF263F50),
                      ),
                      onPressed: onFavoritoTap,
                    ),
                  ),
                )
              ],
            ),
            //Informações sobre o animal
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.nome,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263F50),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${animal.especie} • ${animal.raca}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF568B89), // Verde petróleo
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
                        animal.idade,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.straighten, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        animal.porte,
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
