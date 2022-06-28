import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'defs.dart';
import 'kookboek.dart';

BestandenManager bestandenManager = BestandenManager();

class MaaltijdplannerItemData {
  bool vergrendeld = false;
  bool toonLaden   = false;
  Recept? waarde;
}

class Maaltijdplanner extends StatefulWidget {
  const Maaltijdplanner({Key? key}) : super(key: key);

  @override
  State<Maaltijdplanner> createState() => MaaltijdplannerState();
}

class MaaltijdplannerState extends State<Maaltijdplanner> {
  final willekeurig = Random();
  bool receptenInit = false;
  List<Recept> geladenRecepten = [];


  List<List<MaaltijdplannerItemData>> inhoud = List.generate(
    7, (dag) => List.generate(
      3, (idx) => MaaltijdplannerItemData()
    )
  );
  static List<String> maaltijdNamen = ["ontbijt", "middageten", "avondeten"];

  void toggleGrendelItem(int dag, int index) {
    bool v = inhoud[dag][index].vergrendeld;
    setState(() {
      inhoud[dag][index].vergrendeld = !v;
    });
  }

  void shuffle(BuildContext context, int dag) async {
    if (!receptenInit) {
      List<Recept> recepten = await bestandenManager.getRecepten();
      setState(() {
        geladenRecepten = recepten;
        receptenInit = true;
      });
    }

    if (inhoud[dag].every((element) => element.vergrendeld)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alle maaltijden zijn vergrendeld."))
      );
    }
    
    setState(() {
      for (var element in inhoud[dag]) {
        if (!element.vergrendeld) {
          element.waarde = geladenRecepten[willekeurig.nextInt(geladenRecepten.length)];
          element.toonLaden = true;
        }

        Timer(const Duration(milliseconds: 750), () => setState(() {
          element.toonLaden = false;
        }));
      }
    });
  }

  void kiesRecept(dag, index, Recept? receptOfLeeg) async {
    if (!receptenInit) {
      List<Recept> recepten = await bestandenManager.getRecepten();
      setState(() {
        geladenRecepten = recepten;
        receptenInit = true;
      });
    }

    setState(() {
      inhoud[dag][index].waarde = receptOfLeeg;
    });
  }

  @override
  Widget build(context) {
    return DefaultTabController(
      length: 7,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
              ],
              title: const Text("maaltijdplanner"),
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
                  Tab(text: "ma"),
                  Tab(text: "di"),
                  Tab(text: "wo"),
                  Tab(text: "do"),
                  Tab(text: "vr"),
                  Tab(text: "za"),
                  Tab(text: "zo"),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.shuffle),
              onPressed: () => shuffle(context, DefaultTabController.of(context)!.index),
            ),
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: TabBarView(
                children: List.generate(7, (dag) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(3, (index) {
                        MaaltijdplannerItemData item = inhoud[dag][index];
                        return Flexible(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Builder(
                                  builder: (context) {
                                    if (item.toonLaden) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(maaltijdNamen[index], style: Theme.of(context).textTheme.headline5),
                                          Text(item.waarde != null ? item.waarde!.naam : 'leeg'),
                                          const SizedBox(height: 8,),
                                          Wrap(
                                            
                                            spacing: 12.0,
                                            runSpacing: 12.0,
                                            runAlignment: WrapAlignment.center,
                                            alignment: WrapAlignment.center,
                                            
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () => toggleGrendelItem(dag, index),
                                                icon: item.vergrendeld ? const Icon(Icons.lock_open) : const Icon(Icons.lock_outline),
                                                label: item.vergrendeld ? const Text("ontgrendel keuze") : const Text("vergrendel keuze"),
                                              ),
                  
                                              if (item.waarde != null) ElevatedButton.icon(
                                                onPressed: () => kiesRecept(dag, index, null), 
                                                icon: const Icon(Icons.delete_outline), 
                                                label: const Text("verwijder recept")  
                                              ),
                  
                                              Builder(builder: (context) {
                                                if (item.waarde == null) {
                                                  return ElevatedButton.icon(
                                                    icon: const Icon(Icons.library_add),
                                                    label: const Text("kies een gerecht"),
                                                    onPressed: () async {
                                                      
                                                        int? nieuwRecept = await showDialog(context: context, builder: (context) => SimpleDialog(
                                                          title: Text("kies een gerecht voor het ${maaltijdNamen[index]}"),
                                                          children: List.generate(geladenRecepten.length, (index) {
                                                            Recept recept = geladenRecepten[index];
                                                            return SimpleDialogOption(
                                                              child: Text(recept.naam),
                                                              onPressed: () => Navigator.pop(context, index),
                                                            );
                                                          })
                                                        ));
                  
                                                        if (nieuwRecept != null) {
                                                          kiesRecept(dag, index, geladenRecepten[nieuwRecept]);
                                                        }
                                                      
                                                      
                                                    },
                                                  );
                                                } else {
                                                  return ElevatedButton.icon(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                        return maakReceptPagina(context, item.waarde!);
                                                      }));
                                                    },
                                                    icon: const Icon(Icons.arrow_forward),
                                                    label: const Text("ga naar gerecht"),
                                                    
                                                  );
                                                }
                                              })
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                    ),
                  );
                }),
              )
            ),
          );
        }
      ),
    );
  }
}