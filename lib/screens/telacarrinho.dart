
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorealeza/screens/components/carrinho_compras.dart';
import 'package:projetorealeza/screens/components/minhaappbar.dart';

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);
  static const Color fundo = Color(0xFFFFFBFE);

  final CarrinhoCompras carrinho = CarrinhoCompras.instancia;

  final TextEditingController cepController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController complementoController =
      TextEditingController();

  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController ufController = TextEditingController();

  bool buscandoCep = false;
  bool enderecoEncontrado = false;

  @override
  void dispose() {
    cepController.dispose();
    numeroController.dispose();
    complementoController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    ufController.dispose();
    super.dispose();
  }

  String formatarPreco(double valor) {
    return "R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}";
  }

  InputDecoration decoracaoCampo(String titulo, IconData icone) {
    return InputDecoration(
      labelText: titulo,
      prefixIcon: Icon(icone, color: roxo),
      filled: true,
      fillColor: fundo,
      labelStyle: const TextStyle(color: texto),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: rosa.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: roxo, width: 1.5),
      ),
    );
  }

  Future<void> buscarCep() async {
    final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length != 8) {
      mensagem("Digite um CEP válido com 8 números.", Colors.orange);
      return;
    }

    setState(() {
      buscandoCep = true;
      enderecoEncontrado = false;
    });

    try {
      final resposta = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados['erro'] == true) {
          mensagem("CEP não encontrado.", Colors.redAccent);
          return;
        }

        setState(() {
          ruaController.text = dados['logradouro'] ?? '';
          bairroController.text = dados['bairro'] ?? '';
          cidadeController.text = dados['localidade'] ?? '';
          ufController.text = dados['uf'] ?? '';
          enderecoEncontrado = true;
        });

        mensagem("Endereço encontrado com sucesso!", Colors.green);
      } else {
        mensagem("Não foi possível consultar o CEP.", Colors.redAccent);
      }
    } catch (e) {
      mensagem("Erro de conexão ao consultar o CEP.", Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() {
          buscandoCep = false;
        });
      }
    }
  }

  void mensagem(String textoMensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(textoMensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget campoEndereco(
    String titulo,
    TextEditingController controller,
    IconData icone,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: decoracaoCampo(titulo, icone),
      ),
    );
  }

  Widget construirImagem(String caminho) {
    if (caminho.startsWith('http')) {
      return Image.network(
        caminho,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported_outlined, color: roxo),
      );
    }

    return Image.asset(
      caminho,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.image_not_supported_outlined, color: roxo),
    );
  }

  Widget construirProdutos() {
    if (carrinho.produtos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: roxo,
              ),
              const SizedBox(height: 15),
              const Text(
                "Seu carrinho está vazio!",
                style: TextStyle(
                  fontSize: 18,
                  color: texto,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "Escolha suas artesanatos favoritos na nossa loja. ♡",
                textAlign: TextAlign.center,
                style: TextStyle(color: texto.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: carrinho.produtos.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 13),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color.fromRGBO(255, 169, 249, 1).withOpacity(0.4)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  width: 82,
                  height: 85,
                  color: amarelo.withOpacity(0.5),
                  child: construirImagem(item.imagem),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nome,
                      style: const TextStyle(
                        color: texto,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatarPreco(item.preco),
                      style: const TextStyle(
                        color: roxo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        _botaoQuantidade(
                          Icons.remove,
                          () => carrinho.diminuirQuantidade(item),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "${item.quantidade}",
                            style: const TextStyle(
                              color: texto,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _botaoQuantidade(
                          Icons.add,
                          () => carrinho.aumentarQuantidade(item),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => carrinho.remover(item),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _botaoQuantidade(IconData icone, VoidCallback acao) {
    return InkWell(
      onTap: acao,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: amarelo,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icone, color: roxo, size: 17),
      ),
    );
  }

  Widget construirEndereco() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: rosa.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: roxo, size: 24),
              SizedBox(width: 9),
              Text(
                "Endereço de entrega",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: texto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Informe seu CEP para localizar seu endereço.",
            style: TextStyle(
              color: texto.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cepController,
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  onChanged: (valor) {
                    final numeros = valor.replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );

                    if (numeros.length == 8) {
                      final formatado =
                          '${numeros.substring(0, 5)}-${numeros.substring(5)}';

                      if (cepController.text != formatado) {
                        cepController.value = TextEditingValue(
                          text: formatado,
                          selection: TextSelection.collapsed(
                            offset: formatado.length,
                          ),
                        );
                      }
                    }
                  },
                  decoration: decoracaoCampo(
                    "CEP",
                    Icons.markunread_mailbox_outlined,
                  ).copyWith(
                    hintText: "00000-000",
                    counterText: "",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 53,
                child: ElevatedButton(
                  onPressed: buscandoCep ? null : buscarCep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: roxo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: buscandoCep
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Buscar"),
                ),
              ),
            ],
          ),
          if (enderecoEncontrado) ...[
            const SizedBox(height: 18),
            const Text(
              "Endereço localizado ♡",
              style: TextStyle(
                color: roxo,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),
            campoEndereco(
              "Rua / Logradouro",
              ruaController,
              Icons.signpost_outlined,
            ),
            campoEndereco(
              "Bairro",
              bairroController,
              Icons.location_city_outlined,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: campoEndereco(
                    "Cidade",
                    cidadeController,
                    Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: campoEndereco(
                    "UF",
                    ufController,
                    Icons.map_outlined,
                  ),
                ),
              ],
            ),
            TextField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: decoracaoCampo(
                "Número",
                Icons.home_outlined,
              ),
            ),
            const SizedBox(height: 13),
            TextField(
              controller: complementoController,
              decoration: decoracaoCampo(
                "Complemento (opcional)",
                Icons.apartment_outlined,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: const MinhaAppBar(),
      body: AnimatedBuilder(
        animation: carrinho,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Minhas compras ♡",
                style: TextStyle(
                  color: texto,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${carrinho.quantidadeTotal} item(ns) no carrinho",
                style: TextStyle(
                  color: texto.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 18),
              construirProdutos(),
              const SizedBox(height: 22),
              construirEndereco(),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [amarelo, rosa],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total da compra",
                          style: TextStyle(
                            color: texto,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatarPreco(carrinho.valorTotal),
                          style: const TextStyle(
                            color: texto,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (carrinho.produtos.isEmpty) {
                            mensagem(
                              "Adicione produtos ao carrinho.",
                              Colors.orange,
                            );
                          } else if (!enderecoEncontrado ||
                              numeroController.text.trim().isEmpty) {
                            mensagem(
                              "Consulte o CEP e informe o número do endereço.",
                              Colors.orange,
                            );
                          } else {
                            mensagem(
                              "Endereço preenchido! A finalização da compra será implementada depois.",
                              Colors.green,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: roxo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Continuar compra",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: carrinho.produtos.isEmpty
                          ? null
                          : () => carrinho.limpar(),
                      child: const Text(
                        "Limpar carrinho",
                        style: TextStyle(color: texto),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
