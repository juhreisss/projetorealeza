
import 'package:flutter/material.dart';
import 'package:projetorealeza/screens/telahome.dart';
import 'package:projetorealeza/screens/telaperfil.dart';
import 'package:projetorealeza/screens/telacarrinho.dart';
import 'package:projetorealeza/screens/components/carrinho_compras.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int indexAtual = 0;

  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);

  final List<Widget> paginas = [
    const TelaHome(),
    const TelaCarrinho(),
    const TelaPerfil(),
  ];

  @override
  void initState() {
    super.initState();

    // Carrega os produtos salvos no SharedPreferences
    CarrinhoCompras.instancia.inicializar();
  }

  void mudarIndex(int novoIndex) {
    setState(() {
      indexAtual = novoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = CarrinhoCompras.instancia;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFE),
      body: paginas.elementAt(indexAtual),
      bottomNavigationBar: AnimatedBuilder(
        animation: carrinho,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [amarelo, rosa],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: roxo.withOpacity(0.12),
                  blurRadius: 15,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BottomNavigationBar(
                currentIndex: indexAtual,
                onTap: mudarIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: roxo,
                unselectedItemColor: texto.withOpacity(0.55),
                selectedFontSize: 13,
                unselectedFontSize: 12,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                items: [
                  BottomNavigationBarItem(
                    label: "Home",
                    icon: Icon(
                      indexAtual == 0
                          ? Icons.home_rounded
                          : Icons.home_outlined,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Carrinho",
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          indexAtual == 1
                              ? Icons.shopping_bag_rounded
                              : Icons.shopping_bag_outlined,
                        ),
                        if (carrinho.quantidadeTotal > 0)
                          Positioned(
                            right: -9,
                            top: -7,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 17,
                                minHeight: 17,
                              ),
                              decoration: const BoxDecoration(
                                color: roxo,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${carrinho.quantidadeTotal}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Perfil",
                    icon: Icon(
                      indexAtual == 2
                          ? Icons.person_rounded
                          : Icons.person_outline_rounded,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
