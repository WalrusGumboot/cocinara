import 'package:flutter/material.dart';
import 'defs.dart';

BestandenManager bestandenManager = BestandenManager();


class NieuwIngredientDialoog extends StatefulWidget {
  const NieuwIngredientDialoog({Key? key}) : super(key: key);

  @override
  State<NieuwIngredientDialoog> createState() => NieuwIngredientDialoogState();
}

class NieuwIngredientDialoogState extends State<NieuwIngredientDialoog> {
  String ingredientNaam = "";
  String ingredientEenheid = "";
  int ingredientHoeveelheid = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Nieuw ingrediënt toevoegen aan boodschappenlijst"),
      contentPadding: const EdgeInsets.all(24),
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
            hintText: "Naam v. ingrediënt"
          ),
          onChanged: (text) {
            setState(() {
              ingredientNaam = text;
            });
          },
        ),
        const SizedBox(height: 8,),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                  hintText: "Hoeveelheid v. ingrediënt"
                ),
                onChanged: (text) {
                  setState(() {
                    ingredientHoeveelheid = int.parse(text);
                  });
                },
              ),
            ),
            const SizedBox(width: 8.0,),
            Flexible(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
                  hintText: "Naam v. eenheid"
                ),
                onChanged: (text) {
                  setState(() {
                    ingredientEenheid = text;
                  });
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              }, 
              child: const Text("Annuleer")
            ),
            const SizedBox(width: 8.0,),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, Ingredient(ingredientNaam, ingredientEenheid, ingredientHoeveelheid));
              },
              child: const Text("Voeg toe")
            ),
          ]
        ),
      ]
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

      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FutureBuilder(
          future: bestandenManager.getBoodschappen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Ingredient> lijst = snapshot.data as List<Ingredient>;
              return ListView.builder(
                itemCount: lijst.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: SizedBox(
                      height: 40,
                      child: Center(
                        child: Text("${lijst[index].naam} (${lijst[index].hoeveelheid} ${lijst[index].eenheid})"),
                      ),
                    )
                  );
                }
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_shopping_cart),
        onPressed: () async {          
          Ingredient? mogelijkNieuwIngredient = await showDialog(
            context: context, 
            builder: (context) => const NieuwIngredientDialoog()) as Ingredient?;

          if (mogelijkNieuwIngredient != null) {
            List<Ingredient> huidigeLijst = await bestandenManager.getBoodschappen();
            huidigeLijst.add(mogelijkNieuwIngredient); //HANDMATIG TOEVOEGEN
            bestandenManager.setBoodschappen(huidigeLijst);

            Navigator.popAndPushNamed(context, "/boodschappenlijstje/");
          }

        },
      ),
    );
  }
}