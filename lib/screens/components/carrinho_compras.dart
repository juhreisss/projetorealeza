
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCarrinho {
  final String nome;
  final double preco;
  final String imagem;
  int quantidade;

  ItemCarrinho({
    required this.nome,
    required this.preco,
    required this.imagem,
    this.quantidade = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'preco': preco,
      'imagem': imagem,
      'quantidade': quantidade,
    };
  }

  factory ItemCarrinho.fromJson(Map<String, dynamic> json) {
    return ItemCarrinho(
      nome: json['nome'] ?? '',
      preco: (json['preco'] as num).toDouble(),
      imagem: json['imagem'] ?? '',
      quantidade: (json['quantidade'] as num?)?.toInt() ?? 1,
    );
  }
}

class CarrinhoCompras extends ChangeNotifier {
  CarrinhoCompras._();

  static final CarrinhoCompras instancia = CarrinhoCompras._();

  static const String chaveCarrinho = 'produtos_carrinho';

  final List<ItemCarrinho> produtos = [];

  bool carregado = false;
  Future<void>? _inicializacao;

  int get quantidadeTotal {
    return produtos.fold(
      0,
      (total, item) => total + item.quantidade,
    );
  }

  double get valorTotal {
    return produtos.fold(
      0,
      (total, item) => total + item.preco * item.quantidade,
    );
  }

  Future<void> inicializar() {
    return _inicializacao ??= _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      final preferencias = await SharedPreferences.getInstance();

      final dadosSalvos = preferencias.getString(chaveCarrinho);

      if (dadosSalvos != null && dadosSalvos.isNotEmpty) {
        final List<dynamic> dados = jsonDecode(dadosSalvos);

        produtos.clear();

        for (final produto in dados) {
          produtos.add(
            ItemCarrinho.fromJson(
              Map<String, dynamic>.from(produto),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar carrinho: $e');
    } finally {
      carregado = true;
      notifyListeners();
    }
  }

  Future<void> _salvarProdutos() async {
    try {
      final preferencias = await SharedPreferences.getInstance();

      final dados = produtos.map((item) => item.toJson()).toList();

      await preferencias.setString(
        chaveCarrinho,
        jsonEncode(dados),
      );
    } catch (e) {
      debugPrint('Erro ao salvar carrinho: $e');
    }
  }

  Future<void> adicionar({
    required String nome,
    required double preco,
    required String imagem,
  }) async {
    await inicializar();

    final indice = produtos.indexWhere(
      (item) => item.nome == nome && item.imagem == imagem,
    );

    if (indice >= 0) {
      produtos[indice].quantidade++;
    } else {
      produtos.add(
        ItemCarrinho(
          nome: nome,
          preco: preco,
          imagem: imagem,
        ),
      );
    }

    notifyListeners();
    await _salvarProdutos();
  }

  Future<void> aumentarQuantidade(ItemCarrinho item) async {
    await inicializar();

    item.quantidade++;

    notifyListeners();
    await _salvarProdutos();
  }

  Future<void> diminuirQuantidade(ItemCarrinho item) async {
    await inicializar();

    if (item.quantidade > 1) {
      item.quantidade--;
    } else {
      produtos.remove(item);
    }

    notifyListeners();
    await _salvarProdutos();
  }

  Future<void> remover(ItemCarrinho item) async {
    await inicializar();

    produtos.remove(item);

    notifyListeners();
    await _salvarProdutos();
  }

  // Limpa todo o carrinho.
  Future<void> limpar() async {
    await inicializar();

    produtos.clear();

    notifyListeners();
    await _salvarProdutos();
  }
}
