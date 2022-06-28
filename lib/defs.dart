import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Ingredient {
  final String naam;
  final String eenheid;
  final int    hoeveelheid;

  const Ingredient(this.naam, this.eenheid, this.hoeveelheid);

  Ingredient.fromJson(Map<String, dynamic> json)
    : naam = json["naam"],
      eenheid = json["eenheid"],
      hoeveelheid = json["hoeveelheid"];
  
  Map<String, dynamic> toJson() => {
    'naam': naam,
    'eenheid': eenheid,
    'hoeveelheid': hoeveelheid
  };
}

class Recept {
  final String naam;
  final String blurb;
  final List<Ingredient> ingredienten;
  final String bereiding;

  const Recept(this.naam, this.blurb, this.ingredienten, this.bereiding);

  static Recept fromJson(Map<String, dynamic> json) {
    List<dynamic> ruweIngredienten = json["ingredienten"];
    List<Ingredient> ingredientenLijst = List.generate(ruweIngredienten.length, (index) {
      return Ingredient.fromJson(ruweIngredienten[index]);
    });
    
    return Recept(
      json["naam"], json["blurb"], ingredientenLijst, json["bereiding"]
    );
  }
  
  Map<String, dynamic> toJson() => {
    "naam": naam,
    "blurb": blurb,
    "ingredienten": ingredienten,
    "bereiding": bereiding
  };
}

class BestandenManager {
   Future<String> lokaalPad() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> lijstBestand() async {
    final path = await lokaalPad();
    return File('$path/boodschappenlijst.json');
  }

  Future<File> receptenBestand() async {
    final path = await lokaalPad();
    return File('$path/recepten.json');
  }

  Future<List<Ingredient>> getBoodschappen() async {
    try {
      final bestand = await lijstBestand();
      final inhoud  = await bestand.readAsString();

      Map<String, dynamic> json = jsonDecode(inhoud);

      return List.generate(json['lijst'].length, (index) {
        return Ingredient.fromJson(json['lijst'][index]);
      });
    } catch (e) {
      return [];
    }
  }

  Future<bool> setBoodschappen(List<Ingredient> nieuweLijst) async {
    try {
      final bestand = await lijstBestand();
      bestand.writeAsString(jsonEncode({'lijst': nieuweLijst}));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Recept>> getRecepten() async {
    try {
      final bestand = await receptenBestand();
      final inhoud  = await bestand.readAsString();

      Map<String, dynamic> json = jsonDecode(inhoud);

      List<Recept> lijst = List.generate(json['recepten'].length, (index) =>
        Recept.fromJson(json['recepten'][index])
      );


      return lijst;

    } catch (e) {
      return [];
    }
  }

  Future<bool> setRecepten(List<Recept> nieuweLijst) async {
    try {
      final bestand = await receptenBestand();
      bestand.writeAsString(jsonEncode({'recepten': nieuweLijst}));
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
