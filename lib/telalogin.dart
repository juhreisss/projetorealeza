
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetorealeza/navigation/navbar.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController emailDigitado = TextEditingController();
  final TextEditingController senhaDigitada = TextEditingController();

  bool estaCarregando = false;
  bool ocultarSenha = true;

  // Paleta da Releza
  static const Color amarelo = Color(0xFFFFF7AD);
  static const Color rosa = Color(0xFFFFA9F9);
  static const Color roxo = Color(0xFFAD579D);
  static const Color texto = Color(0xFF493447);

  @override
  void dispose() {
    emailDigitado.dispose();
    senhaDigitada.dispose();
    super.dispose();
  }

  // LOGIN
  void fazerLogin() async {
    if (emailDigitado.text.trim().isEmpty ||
        senhaDigitada.text.trim().isEmpty) {
      _mostrarMensagem("Por favor, preencha todos os campos.");
      return;
    }

    setState(() {
      estaCarregando = true;
    });

    try {
      final respostaServidor = await http.get(
        Uri.parse("https://mercadinhoapi.onrender.com/usuarios"),
      );

      if (respostaServidor.statusCode == 200) {
        final usuarios = jsonDecode(respostaServidor.body);
        bool encontrouUsuario = false;

        for (dynamic usuario in usuarios) {
          if (emailDigitado.text.trim() == usuario['email'] &&
              senhaDigitada.text.trim() == usuario['senha']) {
            usuarioId = usuario['id'];
            usuarioEmail = usuario['email'];
            usuarioSenha = usuario['senha'];

            encontrouUsuario = true;

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavBar(),
                ),
              );
            }
            break;
          }
        }

        if (!encontrouUsuario && mounted) {
          _mostrarMensagem("E-mail ou senha incorretos.");
        }
      } else {
        if (mounted) {
          _mostrarMensagem("Erro ao conectar com o servidor.");
        }
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensagem("Ocorreu um erro. Tente novamente.");
      }
    } finally {
      if (mounted) {
        setState(() {
          estaCarregando = false;
        });
      }
    }
  }

  // MENSAGENS
  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: roxo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // CAMPO PERSONALIZADO
  Widget campoEntrada({
    required TextEditingController controller,
    required String titulo,
    required String dica,
    required IconData icone,
    bool senha = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: senha && ocultarSenha,
      keyboardType:
          senha ? TextInputType.text : TextInputType.emailAddress,
      style: const TextStyle(
        color: texto,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: titulo,
        hintText: dica,
        labelStyle: const TextStyle(color: roxo),
        hintStyle: TextStyle(
          color: texto.withValues(alpha: 0.45),
          fontSize: 14,
        ),
        prefixIcon: Icon(icone, color: roxo),
        suffixIcon: senha
            ? IconButton(
                onPressed: () {
                  setState(() {
                    ocultarSenha = !ocultarSenha;
                  });
                },
                icon: Icon(
                  ocultarSenha
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: roxo,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFFFF9FD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF0D9EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFF0D9EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: roxo,
            width: 1.7,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // GRADIENTE PRINCIPAL AMARELO E ROSA
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF7AD),
              Color(0xFFFFD5D9),
              Color(0xFFFFA9F9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 35,
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),

              child: Card(
                color: Colors.white,
                elevation: 14,
                shadowColor: const Color(0xFFAD579D).withValues(alpha: 0.20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 38,
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // LOGO COM GRADIENTE
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFF7AD),
                              Color(0xFFFFA9F9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.spa_outlined,
                          size: 46,
                          color: texto,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // NOME DA MARCA
                      const Text(
                        "Realeza",
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: roxo,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "BORDADOS ARTESANAIS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                          color: texto,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // DETALHE DECORATIVO
                      Container(
                        width: 65,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [amarelo, rosa],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        "Bem-vinda!",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: texto,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        "Entre na sua conta para continuar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: texto.withValues(alpha: 0.65),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // E-MAIL
                      campoEntrada(
                        controller: emailDigitado,
                        titulo: "E-mail",
                        dica: "Digite seu e-mail",
                        icone: Icons.email_outlined,
                      ),

                      const SizedBox(height: 19),

                      // SENHA
                      campoEntrada(
                        controller: senhaDigitada,
                        titulo: "Senha",
                        dica: "Digite sua senha",
                        icone: Icons.lock_outline,
                        senha: true,
                      ),

                      const SizedBox(height: 30),

                      // BOTÃO ENTRAR COM GRADIENTE
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFA9F9),
                                Color(0xFFAD579D),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: roxo.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed:
                                estaCarregando ? null : fazerLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor:
                                  Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: estaCarregando
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "ENTRAR",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // RODAPÉ
                      Text(
                        "Feito com carinho para você ♡",
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: texto.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// DADOS DO USUÁRIO
dynamic usuarioId;
dynamic usuarioEmail;
dynamic usuarioSenha;
