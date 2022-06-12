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
      home: const Wrapper()
    );
  }
}

class MenuTile extends StatelessWidget {
  final String tekst;
  const MenuTile(this.tekst, {Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return SizedBox(
      height: 80,
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Center(child: Text(tekst, style: Theme.of(context).textTheme.headline5)),
        ),
      ),
    );
  } 
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  WrapperState createState() {
    return WrapperState();
  }
}

class WrapperState extends State<Wrapper> {
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
            MenuTile("kookboek"),
            MenuTile("maaltijdplanner"),
            MenuTile("boodschappenlijst")
          ],
        ),
      ),
    );
  }
}