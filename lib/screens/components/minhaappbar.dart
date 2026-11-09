import 'package:flutter/material.dart';
import 'package:projetorealeza/navigation/navbar.dart';

class MinhaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MinhaAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 255, 177, 252), 
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
            ),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            tooltip: "Voltar",
          ),
          const SizedBox(width: 8),
          const Text(
            "Gestão de Produtos",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}