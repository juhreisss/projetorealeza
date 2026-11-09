
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorealeza/screens/components/produtos.dart';
import 'package:projetorealeza/screens/telagestao.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key});

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  List listaProdutos = [];
  bool estaCarregando = true;

  // Cores da identidade visual Releza
  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);
  static const Color fundo = Color(0xFFFFFAFC);

  @override
  void initState() {
    super.initState();
    fazerGet();
  }

  // Busca os produtos na API
  void fazerGet() async {
    try {
      final respostaServidor = await http.get(
        Uri.parse("https://mercadinhoapi.onrender.com/produtos"),
      );

      if (respostaServidor.statusCode == 200) {
        final dados = jsonDecode(respostaServidor.body);

        if (!mounted) return;

        setState(() {
          listaProdutos = dados;
          estaCarregando = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          estaCarregando = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        estaCarregando = false;
      });
    }
  }

  // Corrige o caminho das imagens recebidas da API
  String corrigirCaminhoImagem(String caminho) {
    String nomeImagem = caminho.replaceFirst('./assets/imagens/', '');

    // Corrige o nome do chinelo marrom escuro
    // if (nomeImagem == 'chinelo_marom_escuro.jpeg') {
    //   nomeImagem = 'chinelo_marrom_escuro.jpeg';
    // }

    return nomeImagem;
  }

  // CABEÇALHO DE BOAS-VINDAS
  Widget construirCabecalho() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            amarelo,
            Color(0xFFFFD5E9),
            rosa,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Olá, seja bem-vinda! ♡",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Descubra nossas peças feitas com carinho.",
            style: TextStyle(
              fontSize: 14,
              color: texto.withOpacity(0.75),
            ),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: roxo,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Artesanato feito à mão, com amor em cada detalhe.",
                    style: TextStyle(
                      fontSize: 12,
                      color: texto,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TÍTULO DO CATÁLOGO
  Widget construirTituloCatalogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 16),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [amarelo, rosa, roxo],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nossas peças",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Escolha seus favoritos!",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          if (!estaCarregando && listaProdutos.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: rosa.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${listaProdutos.length} produtos",
                style: const TextStyle(
                  color: roxo,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // MENSAGEM QUANDO NÃO EXISTEM PRODUTOS
  Widget construirEstadoVazio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: rosa.withOpacity(0.20),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 55,
              color: roxo,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Nenhum produto encontrado",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: texto,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Volte em breve para conferir nossas novidades!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,

      // BARRA SUPERIOR
      appBar: AppBar(
        toolbarHeight: 75,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                amarelo,
                Color(0xFFFFD5E9),
                rosa,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        title: const Row(
          children: [
            Icon(
              Icons.spa_outlined,
              color: texto,
              size: 30,
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Releza",
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),

                Text(
                  "BORDADOS ARTESANAIS",
                  style: TextStyle(
                    fontSize: 8,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
              ],
            ),
          ],
        ),

        // BOTÃO DE GESTÃO
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.65),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaGestao(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings_outlined,
                  color: roxo,
                ),
                tooltip: "Gestão",
              ),
            ),
          ),
        ],
      ),

      // CONTEÚDO PRINCIPAL
      body: Column(
        children: [
          construirCabecalho(),

          construirTituloCatalogo(),

          Expanded(
            child: estaCarregando
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: roxo,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Preparando nossas novidades...",
                          style: TextStyle(
                            color: texto,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )

                : listaProdutos.isEmpty
                    ? construirEstadoVazio()

                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          14,
                          5,
                          14,
                          25,
                        ),

                        itemCount: listaProdutos.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),

                        itemBuilder: (context, index) {
                          final produto = listaProdutos[index];

                          return Produtos(
                            nome: produto['nome'] ?? '',
                            urlImagem: corrigirCaminhoImagem(
                              produto['imagem'] ?? '',
                            ),
                            preco: (produto['preco'] as num).toDouble(),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
