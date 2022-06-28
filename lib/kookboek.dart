import 'package:flutter/material.dart';
import 'defs.dart';

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