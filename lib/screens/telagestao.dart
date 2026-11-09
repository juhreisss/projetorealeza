
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorealeza/navigation/navbar.dart';
import 'package:projetorealeza/screens/components/minhaappbar.dart';

class TelaGestao extends StatefulWidget {
  const TelaGestao({super.key});

  @override
  State<TelaGestao> createState() => _TelaGestaoState();
}

class _TelaGestaoState extends State<TelaGestao> {
  final TextEditingController nomeDigitado = TextEditingController();
  final TextEditingController precoDigitado = TextEditingController();
  final TextEditingController urlDigitado = TextEditingController();

  List listaProdutos = [];
  bool estaSalvando = false;

  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);
  static const Color fundo = Color(0xFFFFFBFE);

  @override
  void initState() {
    super.initState();
    fazerGet();
  }

  @override
  void dispose() {
    nomeDigitado.dispose();
    precoDigitado.dispose();
    urlDigitado.dispose();
    super.dispose();
  }

  void fazerPost() async {
    if (nomeDigitado.text.trim().isEmpty ||
        precoDigitado.text.trim().isEmpty ||
        urlDigitado.text.trim().isEmpty) {
      _mostrarMensagem("Preencha todos os campos!", Colors.orange);
      return;
    }

    setState(() {
      estaSalvando = true;
    });

    try {
      final respostaServidor = await http.post(
        Uri.parse("https://mercadinhoapi.onrender.com/produtos"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": nomeDigitado.text.trim(),
          "preco": double.tryParse(
                precoDigitado.text.replaceAll(',', '.'),
              ) ??
              0.0,
          "imagem": urlDigitado.text.trim(),
        }),
      );

      if (mounted) {
        if (respostaServidor.statusCode == 201) {
          _mostrarMensagem("Produto criado com sucesso!", Colors.green);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavBar()),
          );
        } else {
          _mostrarMensagem("Erro ao criar produto!", Colors.redAccent);
        }
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensagem(
          "Erro de conexão com o servidor.",
          Colors.redAccent,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          estaSalvando = false;
        });
      }
    }
  }

  void fazerGet() async {
    try {
      final respostaServidor = await http.get(
        Uri.parse("https://mercadinhoapi.onrender.com/produtos"),
      );

      if (respostaServidor.statusCode == 200 && mounted) {
        final dados = jsonDecode(respostaServidor.body);

        setState(() {
          listaProdutos = dados;
        });
      }
    } catch (e) {
      // Tratamento de erro silencioso ou log
    }
  }

  void fazerDelete(dynamic id) async {
    try {
      final respostaServidor = await http.delete(
        Uri.parse("https://mercadinhoapi.onrender.com/produtos/$id"),
      );

      if (mounted) {
        if (respostaServidor.statusCode == 200) {
          _mostrarMensagem("Produto deletado com sucesso!", Colors.green);
          fazerGet();
        } else {
          _mostrarMensagem("Erro ao deletar produto!", Colors.redAccent);
        }
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensagem("Erro de conexão.", Colors.redAccent);
      }
    }
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  InputDecoration decoracaoCampo({
    required String titulo,
    required String dica,
    required IconData icone,
  }) {
    return InputDecoration(
      labelText: titulo,
      hintText: dica,
      prefixIcon: Icon(icone, color: const Color.fromARGB(255, 239, 167, 226)),
      filled: true,
      fillColor: fundo,
      labelStyle: const TextStyle(color: texto),
      hintStyle: TextStyle(color: texto.withOpacity(0.45)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: rosa.withOpacity(0.6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: rosa.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: roxo, width: 1.8),
      ),
    );
  }

  Widget construirCabecalho() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [amarelo, rosa],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Área de gestão",
                  style: TextStyle(
                    color: texto,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  "Gerencie suas peças e mantenha sua loja sempre atualizada. ♡",
                  style: TextStyle(
                    color: texto,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.storefront_rounded,
            color: texto,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget construirFormulario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: rosa.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: roxo.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.add_circle_outline_rounded, color: roxo, size: 25),
              SizedBox(width: 9),
              Text(
                "Cadastrar novo produto",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            "Adicione uma nova peça ao catálogo da Releza.",
            style: TextStyle(
              fontSize: 13,
              color: texto.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 22),
          TextField(
            controller: nomeDigitado,
            decoration: decoracaoCampo(
              titulo: "Nome do produto",
              dica: "Ex: Chinelo Rosa",
              icone: Icons.shopping_bag_outlined,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: precoDigitado,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: decoracaoCampo(
              titulo: "Preço do produto",
              dica: "Ex: 15.00",
              icone: Icons.attach_money_rounded,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: urlDigitado,
            decoration: decoracaoCampo(
              titulo: "Caminho da imagem",
              dica: "Ex: ./imagens/chinelorosa.jpeg",
              icone: Icons.image_outlined,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: roxo,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: estaSalvando ? null : fazerPost,
              child: estaSalvando
                  ? const SizedBox(
                      height: 23,
                      width: 23,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border_rounded),
                        SizedBox(width: 9),
                        Text(
                          "Salvar produto",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget construirListaProdutos() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: rosa.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: roxo.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: listaProdutos.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 35,
                horizontal: 20,
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 45,
                      color: roxo.withOpacity(0.55),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Nenhum produto cadastrado.",
                      style: TextStyle(
                        color: texto,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Seus produtos aparecerão aqui.",
                      style: TextStyle(
                        color: texto.withOpacity(0.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listaProdutos.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: rosa.withOpacity(0.3),
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final produto = listaProdutos[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: amarelo.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: roxo,
                    ),
                  ),
                  title: Text(
                    produto['nome'] ?? '',
                    style: const TextStyle(
                      color: texto,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    "R\$ ${produto['preco']?.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(
                      color: roxo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
                    tooltip: "Deletar",
                    onPressed: () => fazerDelete(produto['id']),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: const MinhaAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            construirCabecalho(),
            const SizedBox(height: 24),
            construirFormulario(),
            const SizedBox(height: 28),
            Row(
              children: const [
                Icon(
                  Icons.favorite_rounded,
                  color: roxo,
                  size: 22,
                ),
                SizedBox(width: 9),
                Text(
                  "Produtos cadastrados",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: texto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            construirListaProdutos(),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Feito com carinho ♡ Releza Bordados Artesanais",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: texto.withOpacity(0.55),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
