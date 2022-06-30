import 'package:flutter/material.dart';
import 'defs.dart';
import "boodschappenlijstje.dart";

BestandenManager bestandenManager = BestandenManager();

Widget maakReceptPagina(BuildContext context, Recept recept) {
  return Scaffold(
    appBar: AppBar(
      title: Text(recept.naam),
    ),
    body: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(recept.blurb),
            const SizedBox(height: 16.0),
            Text("Ingrediënten", style: Theme.of(context).textTheme.headline6,),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: recept.ingredienten.length,
                itemBuilder: (context, index) {
                  Ingredient ingredient = recept.ingredienten[index];
                  return Card(
                    child: SizedBox(
                      height: 40,
                      child: Center(child: Text("${ingredient.hoeveelheid} ${ingredient.eenheid} ${ingredient.naam.toLowerCase()}"))
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Text("Bereiding", style: Theme.of(context).textTheme.headline6,),
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    recept.bereiding
                  ),
                ),
              ),
            )
          ],
        )
      ),
    ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add_shopping_cart),
      onPressed: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ingrediënten toegevoegd aan je boodschappenlijstje"))
        );

        List<Ingredient> huidigeLijst = await bestandenManager.getBoodschappen();
        huidigeLijst.addAll(recept.ingredienten);
        bestandenManager.setBoodschappen(huidigeLijst);
      },
    ),
  );
}

class NieuwReceptDialoog extends StatefulWidget {
  const NieuwReceptDialoog({Key? key}) : super(key: key);
  
  @override
  State<NieuwReceptDialoog> createState() => NieuwReceptDialoogState();
}

class NieuwReceptDialoogState extends State<NieuwReceptDialoog> {

  String receptNaam = "";
  String receptBlurb = "";
  List<Ingredient> receptIngredienten = [];
  String receptBereiding = "";


  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Voeg nieuw recept toe"),
      contentPadding: const EdgeInsets.all(24),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Naam van recept",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))
          ),
          onChanged: (text) {setState(() {
            receptNaam = text;
          });},
        ),
        const SizedBox(height: 8.0,),
        TextField(
          decoration: InputDecoration(
            hintText: "Korte beschrijving van recept",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))
          ),
          onChanged: (text) {setState(() {
            receptBlurb = text;
          });},
        ),
        const SizedBox(height: 8.0,),
        //todo: ingredientenlijst
        Wrap(
          children: List.generate(receptIngredienten.length + 1, (index) {
            if (index == receptIngredienten.length) {
              return ActionChip(
                label: Text("voeg ingrediënt toe"),
                onPressed: () async {
                  Ingredient? mogelijkNieuwIngredient = await showDialog(
                    context: context, 
                    builder: (context) => const NieuwIngredientDialoog()) as Ingredient?;

                  if (mogelijkNieuwIngredient != null) {
                    receptIngredienten.add(mogelijkNieuwIngredient); //HANDMATIG TOEVOEGEN
                    setState(() {
                      receptIngredienten = receptIngredienten;
                    });
                  }
                },
              );
            } else {
              Ingredient i = receptIngredienten[index];
              return Chip(
                onDeleted: () {
                  setState(() {
                    receptIngredienten.remove(i);
                  });
                }, //todo
                label: Text(i.naam),
                
              );
            }
          })
        ),
        const SizedBox(height: 8.0,),
        TextField(
          minLines: 3,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: "Bereiding",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))
          ),
          onChanged: (text) {setState(() {
            receptBereiding = text;
          });},
        ),
        const SizedBox(height: 8.0,),
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
                Navigator.pop(context, Recept(
                  receptNaam,
                  receptBlurb,
                  receptIngredienten,
                  receptBereiding
                ));
              },
              child: const Text("Voeg toe")
            ),
          ]
        )
      ],
    );
  }
}

class Kookboek extends StatelessWidget {
  const Kookboek({Key? key}) : super(key: key);

  static List<Ingredient> veelKip = List.filled(3, const Ingredient("Kipblokjes", "gram", 200));


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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.library_add),
        onPressed: () async {
          Recept? nieuwReceptData = await showDialog(
            context: context, 
            builder: (context) => const NieuwReceptDialoog()) as Recept?;
          
          if (nieuwReceptData != null) {
            List<Recept> recepten = await bestandenManager.getRecepten();
            recepten.add(nieuwReceptData);
            bestandenManager.setRecepten(recepten);

            Navigator.popAndPushNamed(context, "/kookboek/");
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FutureBuilder(
          future: bestandenManager.getRecepten(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Recept> recepten = snapshot.data as List<Recept>; 
              return ListView.builder(
                itemCount: recepten.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return maakReceptPagina(context, recepten[index]);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recepten[index].naam,
                                  style: Theme.of(context).textTheme.subtitle1
                                ),
                                Text(
                                  recepten[index].blurb,
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            ),
                            const Icon(Icons.arrow_forward)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
         
        )
      ),
    );
  }
}