import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget _newChatButton() {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 128, 236, 161),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        ),
      ),
      child: Text(
        'COMEÇAR',
        style: GoogleFonts.poppins().copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        'JurisAssistAI',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins().copyWith(
          color: const Color.fromARGB(255, 46, 46, 46),
          fontSize: 24,
        ),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.dehaze),
        //Icon(Icons.dehaze, color: Colors.white)
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.sunny),
          //Icon(Icons.mode_night, color: Colors.white)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'Você ainda não tem nenhuma conversa ativa.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins().copyWith(
                    color: const Color.fromARGB(255, 116, 116, 116),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _newChatButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
