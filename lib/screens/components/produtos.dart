
import 'package:flutter/material.dart';
import 'package:projetorealeza/screens/components/carrinho_compras.dart';

class Produtos extends StatelessWidget {
  final String nome;
  final String urlImagem;
  final double preco;

  const Produtos({
    super.key,
    required this.nome,
    required this.urlImagem,
    required this.preco,
  });

  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);

  Future<void> adicionarAoCarrinho(BuildContext context) async {
    await CarrinhoCompras.instancia.adicionar(
      nome: nome,
      preco: preco,
      imagem: urlImagem,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$nome adicionado ao carrinho!',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: roxo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se a imagem é um link da web ou um arquivo local
    bool ehLinkWeb =
        urlImagem.startsWith('http://') ||
        urlImagem.startsWith('https://');

    return Card(
      elevation: 3,
      shadowColor: roxo.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem do produto
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: ehLinkWeb
                    ? Image.network(
                        urlImagem,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      )
                    : Image.asset(
                        urlImagem,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 9),

            // Nome do produto
            Text(
              nome,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: texto,
              ),
            ),

            const SizedBox(height: 5),

            // Preço
            Text(
              "R\$ ${preco.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: roxo,
              ),
            ),

            const SizedBox(height: 9),

            // Botão adicionar ao carrinho
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton.icon(
                onPressed: () => adicionarAoCarrinho(context),
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 17,
                ),
                label: const Text(
                  "Adicionar",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: rosa,
                  foregroundColor: texto,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
