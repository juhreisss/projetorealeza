
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorealeza/telalogin.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final TextEditingController emailTrocar = TextEditingController();
  bool estaAtualizando = false;

  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);
  static const Color fundo = Color(0xFFFFFBFE);

  @override
  void initState() {
    super.initState();
    emailTrocar.text = usuarioEmail ?? '';
  }

  @override
  void dispose() {
    emailTrocar.dispose();
    super.dispose();
  }

  void fazerPatch(dynamic id) async {
    final email = emailTrocar.text.trim();

    if (email.isEmpty) {
      _mostrarMensagem("O e-mail não pode estar vazio.", Colors.orange);
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _mostrarMensagem("Digite um e-mail válido.", Colors.orange);
      return;
    }

    if (id == null) {
      _mostrarMensagem("Não foi possível identificar sua conta.", Colors.redAccent);
      return;
    }

    setState(() {
      estaAtualizando = true;
    });

    try {
      final respostaServidor = await http.patch(
        Uri.parse("https://mercadinhoapi.onrender.com/usuarios/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (!mounted) return;

      if (respostaServidor.statusCode == 200) {
        setState(() {
          usuarioEmail = email;
        });

        _mostrarMensagem(
          "E-mail atualizado com sucesso!",
          Colors.green,
        );
      } else {
        _mostrarMensagem(
          "Erro ao atualizar e-mail.",
          Colors.redAccent,
        );
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
          estaAtualizando = false;
        });
      }
    }
  }

  void sair() {
    usuarioEmail = null;
    usuarioSenha = null;
    usuarioId = null;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (route) => false,
    );
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  InputDecoration decoracaoCampo({
    required String label,
    required IconData icone,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, color: roxo),
      filled: true,
      fillColor: fundo,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: rosa.withOpacity(0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: roxo, width: 1.5),
      ),
      labelStyle: const TextStyle(color: texto),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 28,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Cabeçalho
              const Text(
                "Meu Perfil",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: texto,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Gerencie suas informações",
                style: TextStyle(
                  fontSize: 14,
                  color: texto.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              // Cartão de perfil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [amarelo, rosa],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: roxo.withOpacity(0.13),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 43,
                        backgroundColor: roxo,
                        child: Icon(
                          Icons.person_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Bem-vindo(a)!",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      usuarioEmail ?? "Seu perfil Releza",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: texto,
                      ),
                    ),

                    const SizedBox(height: 13),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            color: roxo,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Releza Bordados Artesanais",
                            style: TextStyle(
                              color: texto,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Área de atualização
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: roxo.withOpacity(0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.manage_accounts_rounded,
                          color: roxo,
                          size: 24,
                        ),
                        SizedBox(width: 9),
                        Text(
                          "Dados da conta",
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
                      "Mantenha suas informações atualizadas.",
                      style: TextStyle(
                        fontSize: 12,
                        color: texto.withOpacity(0.6),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "E-mail cadastrado",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),

                    const SizedBox(height: 9),

                    TextField(
                      controller: emailTrocar,
                      keyboardType: TextInputType.emailAddress,
                      decoration: decoracaoCampo(
                        label: "Seu e-mail",
                        icone: Icons.email_outlined,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: estaAtualizando
                            ? null
                            : () => fazerPatch(usuarioId),
                        icon: estaAtualizando
                            ? const SizedBox(
                                height: 19,
                                width: 19,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 20),
                        label: Text(
                          estaAtualizando
                              ? "Salvando..."
                              : "Salvar alterações",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: roxo,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: roxo.withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Botão de sair
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: sair,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    "Sair da conta",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: BorderSide(
                      color: Colors.redAccent.withOpacity(0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                "Feito com carinho 💗",
                style: TextStyle(
                  color: texto.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
