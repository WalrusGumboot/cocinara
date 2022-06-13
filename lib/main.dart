import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cocinara',
      theme: maakThemaAan(Brightness.dark),
      home: const HomePagina(),
      routes: {
        "/kookboek/": (context) => const Kookboek(),
        "/maaltijden/": (context) => const Maaltijdplanner(),
        "/boodschappen/": (context) => const Boodschappenlijst(),
      }
    );
  }
}

class MenuTile extends StatelessWidget {
  final String tekst;
  final String doel;
  const MenuTile(this.tekst, this.doel, {Key? key}) : super(key: key);


  @override
  Widget build(context) {
    return SizedBox(
      height: 80,
      child: Card(
        child: InkWell(
          onTap: () {Navigator.of(context).pushNamed(doel);},
          child: Center(child: Text(tekst, style: Theme.of(context).textTheme.headline5)),
        ),
      ),
    );
  } 
}

class HomePagina extends StatelessWidget {
  const HomePagina({Key? key}) : super(key: key);

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
            MenuTile("kookboek", "/kookboek/"),
            MenuTile("maaltijdplanner", "/maaltijden/"),
            MenuTile("boodschappenlijst", "/boodschappen/")
          ],
        ),
      ),
    );
  }
}

class Kookboek extends StatelessWidget {
  const Kookboek({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
        title: const Text("kookboek"),
        centerTitle: true,
      ),

      body: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("hoi"),)
      ),
    );
  }
}

class Maaltijdplanner extends StatelessWidget {
  const Maaltijdplanner({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
        title: const Text("maaltijdplanner"),
        centerTitle: true,
      ),

      body: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("hoi 2"),)
      ),
    );
  }
}

class Boodschappenlijst extends StatelessWidget {
  const Boodschappenlijst({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
        title: const Text("boodschappenlijst"),
        centerTitle: true,
      ),

      body: const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("hoi 3"),)
      ),
    );
  }
}