import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'maaltijdplanner.dart';
import 'boodschappenlijstje.dart';
import 'kookboek.dart';

void main() {
  runApp(const App());
}

ThemeData maakThemaAan(Brightness helderheid) {
  var basisThema = ThemeData(
    brightness: helderheid,
    primarySwatch: Colors.teal,
  );
  return basisThema.copyWith(
    textTheme: GoogleFonts.interTextTheme(basisThema.textTheme)
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocinara',
      theme: maakThemaAan(Brightness.dark),
      home: const HomePagina(),
      routes: {
        "/kookboek/": (context) => const Kookboek(),
        "/maaltijdplanner/": (context) => const Maaltijdplanner(),
        "/boodschappenlijstje/": (context) => const Boodschappenlijst(),
      }
    );
  }
}

class MenuItem extends StatelessWidget {
  final String naam;
  const MenuItem(this.naam, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Card(
        child: InkWell(
          onTap: () {Navigator.of(context).pushNamed("/$naam/");},
          child: Center(child: Text(naam, style: Theme.of(context).textTheme.headline5)),
        ),
      ),
    );
  }
}

class HomePagina extends StatefulWidget {
  const HomePagina({Key? key}) : super(key: key);
  
  @override
  State<HomePagina> createState() => _HomePaginaState();
}

class _HomePaginaState extends State<HomePagina> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
        title: const Text("cocinara"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            MenuItem("kookboek"),
            MenuItem("maaltijdplanner"),
            MenuItem("boodschappenlijstje"),
          ],
        ),
      ),
    );
  }
}