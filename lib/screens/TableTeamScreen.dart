import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uli_doation/coponent/dropdown.dart';
import 'package:uli_doation/modele/fonctions.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class test3 extends StatefulWidget {
  const test3({super.key});

  @override
  State<test3> createState() => _test3State();
}

List<String> taille = ['S', 'M', 'L', 'XL', 'XXL'];
String selectedTailleCalecon = 'S';
List<int> quantite = [1, 2, 3, 4, 5, 6];
int selectedQuantiteCalecon = 1;
/////////////////////////////////////////
int selectedQuantiteChaussette = 1;
String selectedTailleChaussette = '39/40';
List<int> quantiteChaussette = [1, 2, 3, 4, 5, 6];
List<String> taileChaussette = ['39/40', '41/42', '43/44', '45/46', '47/48'];
//////////////////////////////////////////////
int selectedQuantiteMalliot = 1;
String selectedTailleMalliot = 'S';
/////////////////////////////////////////////////
int selectedQuantiteTshirt = 1;
String selectedTailleTshirt = 'S';
/////////////////////////////////

int selectedQuantiteTourDeCou = 1;
/////////////
int selectedSavonsDeMarseille = 12;
List quantiteSavons = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
/////////////
int selectedQuantiteSavonnette = 12;
/////////////////
int selectedBonnet = 1;
List quantiteBonnet = [1, 2];

int selectedEquipe = 1;
List<int> equipe = [1, 2, 3, 4, 5];
String selectedSecteur = 'Amont Fer';
List<String> secteur = ['Amont Fer', 'Aval Fer', 'Amont Parc', 'Aval Parc'];
TextEditingController nomController = TextEditingController();
TextEditingController prenomController = TextEditingController();

int selectedQuantiteSousGant = 1;
List<int> quantiteSousGant = [1, 2, 3, 4, 5];

int selectedQuantiteServiette = 1;
List<int> quantiteServiette = [1, 2, 3, 4, 5];

int selectedQuantiteDrapBain = 1;
List<int> quantiteDrapBain = [1, 2, 3, 4, 5];

int selectedQuantiteGelDouche = 1;
List<int> quantiteGelDouche = [1, 2, 3, 4, 5];

class Article {
  final String nom;
  final double prix;
  final int quantite;

  Article(this.nom, this.prix, this.quantite);

  double get total => prix * quantite;
}

class _test3State extends State<test3> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, double> prixArticles = {};
  Map<String, int> totalParEquipe = {};

  @override
  void initState() {
    super.initState();
    _loadPrixArticles();
  }

  Future<void> _loadPrixArticles() async {
    try {
      final snapshot = await _firestore.collection('articles').get();
      setState(() {
        prixArticles = Map.fromEntries(
          snapshot.docs.map((doc) {
            final data = doc.data();
            print(
                'Article chargé: ${data['nom']} - Prix: ${data['prix']}€'); // Debug print
            return MapEntry(data['nom'] ?? '', (data['prix'] ?? 0).toDouble());
          }),
        );
      });
      print('Prix articles chargés: $prixArticles'); // Debug print
    } catch (e) {
      print('Erreur lors du chargement des prix: $e');
    }
  }

  List<Article> getArticles(Map<String, dynamic> agent) {
    // Debug print pour voir les prix disponibles
    print('Prix disponibles lors de getArticles: $prixArticles');

    return [
      Article('Caleçons', prixArticles['Caleçons'] ?? 0,
          totalParEquipe['Caleçons'] ?? 0),
      Article('Chaussettes', prixArticles['Chaussettes'] ?? 0,
          agent['chaussettes quantite'] ?? 0),
      Article('Malliots', prixArticles['Malliots'] ?? 0,
          agent['malliots quantite'] ?? 0),
      Article(
          'Tshirt', prixArticles['Tshirt'] ?? 0, agent['tshirt quantite'] ?? 0),
      Article('Tour de cou', prixArticles['Tour de cou'] ?? 0,
          agent['tourdecou2_quantite'] ?? 0),
      Article('Savon', prixArticles['Savon'] ?? 0,
          agent['savon_marseille_quantite'] ?? 0),
      Article('Savonnette', prixArticles['Savonnette'] ?? 0,
          agent['savonnette_marseille_quantite'] ?? 0),
      Article(
          'Bonnet', prixArticles['Bonnet'] ?? 0, agent['bonnet_quantite'] ?? 0),
      Article('Sous gant', prixArticles['Sous gant'] ?? 0,
          agent['sous_gant_quantite'] ?? 0),
      Article('Serviette', prixArticles['Serviette'] ?? 0,
          agent['serviette_quantite'] ?? 0),
      Article('Drap bain', prixArticles['Drap bain'] ?? 0,
          agent['drap_bain_quantite'] ?? 0),
      Article('Gel douche', prixArticles['Gel douche'] ?? 0,
          agent['gel_douche_quantite'] ?? 0),
    ];
  }

  double calculerTotalAgent(Map<String, dynamic> agent) {
    List<Article> articles = getArticles(agent);
    double total = articles.fold(0, (sum, article) => sum + article.total);

   
    

    return total;
  }

  // Ajoutez cette fonction pour vérifier si on peut commander plus d'un article

  peutCommanderPlus(
      Map<String, dynamic> agent, String article, double prixUnitaire) {
    double plafond = 160;

    double totalActuel = calculerTotalAgent(agent);

    return (totalActuel + prixUnitaire) <= plafond;
  }

  // Modifiez la fonction testCouleur
  Color testCouleur(Map<String, dynamic> agent) {
    double plafond = 160;
    double totalEuros = calculerTotalAgent(agent);

    if (totalEuros >= plafond) {
      return Colors.red; // Return red if over the limit
    }
    return Colors.transparent; // Return transparent otherwise
  }

  // Ajoutez cette fonction pour obtenir la couleur du texte de quantité
  TextStyle getQuantityTextStyle(
      Map<String, dynamic> agent, String article, double prixUnitaire) {
    Color couleur = testCouleur(agent); // Await the result
    if (couleur == Colors.transparent &&
        peutCommanderPlus(agent, article, prixUnitaire)) {
      return TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
    }
    return TextStyle(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: StreamBuilder(
          stream: checkAuth(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur : ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("Aucun utilisateur connecté"));
            }

            final listAgent = snapshot.data?.docs.map((doc) {
              final data = doc.data();
              data['uid'] = doc.id;
              print('Agent ID: ${doc.id}');
              return data;
            }).toList();

            return Row(
              children: [
                // Colonnes fixes
                SizedBox(
                  width: 250, // Augmentez cette valeur si nécessaire
                  child: DataTable(
                      columnSpacing: 10,
                      border: TableBorder(
                          verticalInside:
                              BorderSide(width: 0.5, color: Colors.grey),
                          right: BorderSide(
                              color: Colors.black,
                              width: 2) // Ajoute une bordure visible
                          ),
                      columns: const [
                        DataColumn(label: Text('')),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text('Nom')),
                        DataColumn(
                            headingRowAlignment: MainAxisAlignment.center,
                            label: Text('Prénom')),
                      ],
                      rows: listAgent
                              ?.map((agent) => DataRow(
                                      color: MaterialStateProperty.resolveWith(
                                          (states) {
                                        return Colors
                                            .transparent; // Default color
                                      }),
                                      cells: [
                                        // Icône de modification
                                        DataCell(SizedBox(
                                          width: 40,
                                          child: IconButton(
                                              onPressed: () => showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Modification de l\'agent'),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              'Nom: ${agent['nom']}'),
                                                          Text(
                                                              'Prénom: ${agent['prenom']}'),
                                                          Row(
                                                            children: [
                                                              Text('Equipe: '),
                                                              SizedBox(
                                                                  width: 10),
                                                              ReusableDropdown(
                                                                value: agent[
                                                                    'equipe'],
                                                                items: equipe,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedEquipe =
                                                                        value
                                                                            as int;
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text('Secteur: '),
                                                              SizedBox(
                                                                  width: 10),
                                                              ReusableDropdown(
                                                                value: agent[
                                                                    'secteur'],
                                                                items: secteur,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedSecteur =
                                                                        value;
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                          Center(
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .delete();
                                                                },
                                                                icon: Icon(Icons
                                                                    .delete)),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _firestore
                                                                        .collection(
                                                                            'user')
                                                                        .doc(agent[
                                                                            'uid'])
                                                                        .update({
                                                                      'equipe':
                                                                          selectedEquipe,
                                                                      'secteur':
                                                                          selectedSecteur
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          WidgetStatePropertyAll(Colors
                                                                              .green)),
                                                                  child: Text(
                                                                      'Enregistrer')),
                                                              ElevatedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          WidgetStatePropertyAll(Colors
                                                                              .red)),
                                                                  child: Text(
                                                                      'Annuler'))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                              icon: Icon(
                                                Icons.manage_accounts_rounded,
                                                color: Color(0xffc01271),
                                              )),
                                        )),
                                        // Nom
                                        DataCell(Center(
                                            child: Text(agent['nom'] ?? ''))),
                                        // Prénom
                                        DataCell(Expanded(
                                          child: Center(
                                              child:
                                                  Text(agent['prenom'] ?? '')),
                                        )),
                                      ]))
                              .toList() ??
                          []),
                ),
                // Colonnes défilantes
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      border: TableBorder(
                        verticalInside:
                            BorderSide(width: 0.5, color: Colors.grey),
                      ),
                      columns: const [
                        DataColumn(
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Caleçons'),
                              SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Qté', style: TextStyle(fontSize: 10)),
                                  SizedBox(width: 10),
                                  Text('Taille',
                                      style: TextStyle(fontSize: 10)),
                                ],
                              )
                            ],
                          ),
                        ),
                        DataColumn(
                            label: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Chaussettes'),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Qté',
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Taille',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        )),
                        DataColumn(
                            label: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Malliots'),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Qté',
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Taille',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        )),
                        DataColumn(
                            label: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Tshirt'),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  'Qté',
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Taille',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        )),
                        DataColumn(
                            label: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Tour de cou'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Qté', style: TextStyle(fontSize: 10)),
                          ],
                        )),
                        DataColumn(label: Text('Savon de\nMarseille')),
                        DataColumn(label: Text('Savonnette\nMarseille')),
                        DataColumn(label: Text('Bonnet\nanti-froid')),
                        DataColumn(label: Text('Sous gant\Qté')),
                        DataColumn(label: Text('Serviettes\nQté')),
                        DataColumn(label: Text('Drap de bain\nQté')),
                        DataColumn(label: Text('Gel douche\nQté')),
                      ],
                      rows: listAgent
                              ?.map((agent) => DataRow(
                                      color: MaterialStateProperty.all(
                                          Colors.transparent),
                                      cells: [
                                        // Caleçons
                                        DataCell(
                                          Center(
                                            child: Text(
                                              (agent['calecons quantite'] ??
                                                      '0')
                                                  .toString(),
                                              style: getQuantityTextStyle(
                                                  agent,
                                                  'Caleçons',
                                                  prixArticles['Caleçons'] ??
                                                      0),
                                            ),
                                          ),
                                        ),
                                        // Chaussettes
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Chausettes'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(agent['nom']),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(agent[
                                                                'prenom']),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteChaussette,
                                                                items:
                                                                    quantiteChaussette,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteChaussette =
                                                                        value ??
                                                                            0;
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Taille: '),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedTailleChaussette,
                                                                items:
                                                                    taileChaussette,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedTailleChaussette =
                                                                        value ??
                                                                            '39/40';
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  updateChaussettesInfo(
                                                                      agent[
                                                                          'uid'],
                                                                      selectedTailleChaussette,
                                                                      selectedQuantiteChaussette);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: (agent['chaussettes quantite'] ??
                                                                  0) *
                                                              7.57 >=
                                                          160
                                                      ? Colors
                                                          .red // Colorie la cellule si Chaussettes dépasse
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      (agent['chaussettes quantite'] ??
                                                              '0')
                                                          .toString(),
                                                      style:
                                                          getQuantityTextStyle(
                                                              agent,
                                                              'Chaussettes',
                                                              7.57)),
                                                  SizedBox(width: 20),
                                                  Text(agent[
                                                          'chaussettes taille'] ??
                                                      '39/40'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                        // Maillots
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Malliots'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(agent['nom']),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(agent[
                                                                'prenom']),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteMalliot,
                                                                items: quantite,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteMalliot =
                                                                        value ??
                                                                            0;
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Taille: '),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedTailleMalliot,
                                                                items: taille,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedTailleCalecon =
                                                                        value ??
                                                                            'S';
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  updateMalliotsInfo(
                                                                      agent[
                                                                          'uid'],
                                                                      selectedTailleMalliot,
                                                                      selectedQuantiteMalliot);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: (agent['maillots quantite'] ??
                                                                  0) *
                                                              1.75 >=
                                                          160
                                                      ? Colors
                                                          .red // Colorie la cellule si Malliots dépasse
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      (agent['maillots quantite'] ??
                                                              '0')
                                                          .toString(),
                                                      style:
                                                          getQuantityTextStyle(
                                                              agent,
                                                              'Maillots',
                                                              1.75)),
                                                  SizedBox(width: 20),
                                                  Text(agent[
                                                          'maillots taille'] ??
                                                      '39/40'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                        //T-shirt
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification T-shirt'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(agent['nom']),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(agent[
                                                                'prenom']),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteTshirt,
                                                                items: quantite,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteTshirt =
                                                                        value ??
                                                                            0;
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Taille: '),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedTailleTshirt,
                                                                items: taille,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedTailleTshirt =
                                                                        value ??
                                                                            'S';
                                                                  });
                                                                })
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  updateTshirtInfo(
                                                                      agent[
                                                                          'uid'],
                                                                      selectedTailleTshirt,
                                                                      selectedQuantiteTshirt);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        WidgetStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: (agent['tshirt quantite'] ??
                                                                  0) *
                                                              1.75 >=
                                                          160
                                                      ? Colors
                                                          .red // Colorie la cellule si Malliots dépasse
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    (agent['Tshirt quantite'] ??
                                                            '0')
                                                        .toString(),
                                                    style: getQuantityTextStyle(
                                                        agent, 'Tshirt', 2.69),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(agent['Tshirt taille'] ??
                                                      '39/40'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                        // Tour de cou
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Tour de cou'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteTourDeCou,
                                                                items: quantite,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteTourDeCou =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'tourdecou2_quantite':
                                                                        selectedQuantiteTourDeCou,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['tourdecou2_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent,
                                                    'Tour de cou',
                                                    36.59)),
                                          ),
                                        )),
                                        // Savon de Marseille
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Savon de Marseille'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedSavonsDeMarseille,
                                                                items:
                                                                    quantiteSavons,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedSavonsDeMarseille =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'savon_marseille_quantite':
                                                                        selectedSavonsDeMarseille,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['savon_marseille_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent,
                                                    'Savon de Marseille',
                                                    1.47)),
                                          ),
                                        )),
                                        // Savonnette de Marseille
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Savonnette de Marseille'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteSavonnette,
                                                                items:
                                                                    quantiteSavons,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteSavonnette =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'savonnette_marseille_quantite':
                                                                        selectedQuantiteSavonnette,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['savonnette_marseille_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent,
                                                    'Savonnette de Marseille',
                                                    0.36)),
                                          ),
                                        )),
                                        // Bonnet anti-froid
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Bonnet anti-froid'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedBonnet,
                                                                items:
                                                                    quantiteBonnet,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedBonnet =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedBonnet,
                                                                items:
                                                                    quantiteBonnet,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedBonnet =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'bonnet_quantite':
                                                                        selectedBonnet,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['bonnet_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent, 'Bonnet', 6.51)),
                                          ),
                                        )),
                                        // Sous gant
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Sous gant'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteSousGant,
                                                                items:
                                                                    quantiteSousGant,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteSousGant =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'sous_gant_quantite':
                                                                        selectedQuantiteSousGant,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['sous_gant_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent, 'Sous gant', 2.58)),
                                          ),
                                        )),
                                        // Serviettes
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Serviettes'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteServiette,
                                                                items:
                                                                    quantiteServiette,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteServiette =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'serviette_quantite':
                                                                        selectedQuantiteServiette,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['serviette_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent, 'Serviette', 4.29)),
                                          ),
                                        )),
                                        // Drap de bain
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Drap de bain'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteDrapBain,
                                                                items:
                                                                    quantiteDrapBain,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteDrapBain =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'drap_bain_quantite':
                                                                        selectedQuantiteDrapBain,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['drap_bain_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent,
                                                    'Drap de bain',
                                                    7.84)),
                                          ),
                                        )),
                                        // Gel douche
                                        DataCell(Center(
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Modification Gel douche'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${agent['nom']} ${agent['prenom']}'),
                                                        Row(
                                                          children: [
                                                            Text('Quantité: '),
                                                            ReusableDropdown(
                                                                value:
                                                                    selectedQuantiteGelDouche,
                                                                items:
                                                                    quantiteGelDouche,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedQuantiteGelDouche =
                                                                        value
                                                                            as int;
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  _firestore
                                                                      .collection(
                                                                          'user')
                                                                      .doc(agent[
                                                                          'uid'])
                                                                      .update({
                                                                    'gel_douche_quantite':
                                                                        selectedQuantiteGelDouche,
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .green)),
                                                                child: Text(
                                                                    'Enregistrer')),
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(Colors
                                                                            .red)),
                                                                child: Text(
                                                                    'Annuler'))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            child: Text(
                                                (agent['gel_douche_quantite'] ??
                                                        '0')
                                                    .toString(),
                                                style: getQuantityTextStyle(
                                                    agent, 'Gel douche', 4.20)),
                                          ),
                                        )),
                                      ]))
                              .toList() ??
                          [],
                    ),
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Ajouter un agent'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(hintText: 'Nom'),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    TextField(
                      controller: prenomController,
                      decoration: InputDecoration(hintText: 'Prénom'),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    Row(
                      children: [
                        Text('Equipe'),
                        SizedBox(width: 10),
                        DropdownButton<int>(
                            value: selectedEquipe,
                            items: equipe.map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedEquipe = newValue!;
                              });
                            }),
                      ],
                    ),
                    Row(children: [
                      Text('Secteur'),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                          value: selectedSecteur,
                          items: secteur.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSecteur = newValue!;
                            });
                          }),
                    ]),
                    ElevatedButton(
                        onPressed: () {
                          try {
                            _firestore.collection('user').add({
                              'nom': nomController.text,
                              'prenom': prenomController.text,
                              'equipe': selectedEquipe,
                              'secteur': selectedSecteur,
                            });
                            Navigator.pop(context);
                          } catch (e) {
                            print('Erreur: $e');
                          }
                        },
                        child: Text('Enregistrer'))
                  ],
                ),
              );
            }),
        child: Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
