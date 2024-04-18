import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//rgba(1, 137, 16, 3);

class Register extends StatelessWidget {
  const Register({super.key});

  Widget _logoContainer() {
    return Column(
      children: [
        const Icon(
          Icons.balance,
          color: Colors.white,
          size: 125,
        ),
        Text(
          'JurisAssistAI',
          style: GoogleFonts.poppins().copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Seu assistente pessoal para documentos jurídicos.',
          style: GoogleFonts.poppins().copyWith(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _userTextField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Icon(
            Icons.person,
            color: Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Usuário',
        hintStyle: GoogleFonts.roboto().copyWith(color: Colors.black87),
      ),
    );
  }

  Widget _pwTextField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Icon(
            Icons.password,
            color: Colors.black,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Senha',
        hintStyle: GoogleFonts.roboto().copyWith(color: Colors.black87),
      ),
    );
  }

  Widget _esqueciMinhaSenhaButton() {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Esqueci minha senha',
        style: GoogleFonts.roboto().copyWith(color: Colors.white),
      ),
    );
  }

  Widget _loginButton() {
    return TextButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            label: Text(
              'ENTRAR',
              style: GoogleFonts.roboto()
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(148, 156, 28, 14),
              ),
              overlayColor: MaterialStatePropertyAll(
                Color.fromARGB(147, 212, 43, 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerRow() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white70,
            indent: 10,
            endIndent: 20,
          ),
        ),
        Text(
          'Ou',
          style: GoogleFonts.roboto().copyWith(color: Colors.white),
        ),
        const Expanded(
          child: Divider(
            color: Colors.white70,
            indent: 20,
            endIndent: 10,
          ),
        ),
      ],
    );
  }

  Widget _registerButton() {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Registrar-se',
        style: GoogleFonts.roboto()
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(149, 124, 18, 6),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, bottom: 40, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _logoContainer(),
              Column(
                children: [
                  _userTextField(),
                  const SizedBox(height: 15),
                  _pwTextField(),
                  Row(
                    children: [
                      _esqueciMinhaSenhaButton(),
                    ],
                  ),
                ],
              ),
              _loginButton(),
              _dividerRow(),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }
}
