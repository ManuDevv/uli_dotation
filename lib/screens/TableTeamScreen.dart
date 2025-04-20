import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uli_doation/coponent/dropdown.dart';
import 'package:uli_doation/fichier%20test/test2.dart';
import 'package:uli_doation/modele/fonctions.dart';
import 'package:uli_doation/style/font.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class test3 extends StatefulWidget {
  const test3({super.key});

  @override
  State<test3> createState() => _test3State();
}

List<String> taille = ['S', 'M', 'L', 'XL', '2XL', '3XL'];
String selectedTailleCalecon = 'S';
List<int> quantite = [0, 1, 2, 3, 4, 5, 6];
int selectedQuantiteCalecon = 1;
/////////////////////////////////////////
int selectedQuantiteChaussette = 1;
String selectedTailleChaussette = '39/40';
List<int> quantiteChaussette = [0, 1, 2, 3, 4, 5, 6];
List<String> taileChaussette = ['39/42', '43/45', '46/48'];
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
List quantiteSavons = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
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
List<int> quantiteSousGant = [0, 1, 2, 3, 4, 5];

int selectedQuantiteServiette = 1;
List<int> quantiteServiette = [0, 1, 2, 3, 4, 5];

int selectedQuantiteDrapBain = 1;
List<int> quantiteDrapBain = [0, 1, 2, 3, 4, 5];

int selectedQuantiteGelDouche = 1;
List<int> quantiteGelDouche = [0, 1, 2, 3, 4, 5];

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
  double plafond = 160.0; // Valeur par défaut

  @override
  void initState() {
    super.initState();
    _loadPrixArticles();
    _loadPlafond();
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
      print(
          'Prix articles chargés: $prixArticles'); // Debug print pour vérifier
    } catch (e) {
      print('Erreur lors du chargement des prix: $e');
    }
  }

  // Ajoutez cette fonction pour charger le plafond
  Future<void> _loadPlafond() async {
    try {
      final doc =
          await _firestore.collection('parametres').doc('plafond').get();
      if (doc.exists) {
        setState(() {
          plafond = doc.data()?['montant'] ?? 160.0;
          print('le plafond est de : $plafond');
        });
      }
    } catch (e) {
      print('Erreur lors du chargement du plafond: $e');
    }
  }

  // Modifiez la fonction qui calcule le total pour l'agent
  double calculerTotalAgent(Map<String, dynamic> agent) {
    double total = 0;

    // Ajoutez ces prints pour déboguer
    //  print('Prix des articles: $prixArticles');
    // print('Agent data: $agent');

    // Calculez le total pour chaque article
    double totalCalecons =
        (agent['calecons_quantite'] ?? 0) * (prixArticles['Caleçons'] ?? 0);
    double totalChaussettes = (agent['chaussettes_quantite'] ?? 0) *
        (prixArticles['Chaussettes'] ?? 0);
    double totalMalliots =
        (agent['maillots_quantite'] ?? 0) * (prixArticles['Malliots'] ?? 0);
    double totalTshirt =
        (agent['tshirt_quantite'] ?? 0) * (prixArticles['Tshirt'] ?? 0);
    double totalTourDeCou = (agent['tourdecou2_quantite'] ?? 0) *
        (prixArticles['Tour de cou'] ?? 0);
    double totalSavon =
        (agent['savon_marseille_quantite'] ?? 0) * (prixArticles['Savon'] ?? 0);
    double totalSavonnette = (agent['savonnette_marseille_quantite'] ?? 0) *
        (prixArticles['Savonnette'] ?? 0);
    double totalBonnet =
        (agent['bonnet_quantite'] ?? 0) * (prixArticles['Bonnet'] ?? 0);
    double totalSousGant =
        (agent['sous_gant_quantite'] ?? 0) * (prixArticles['Sous gant'] ?? 0);
    double totalServiettes =
        (agent['serviette_quantite'] ?? 0) * (prixArticles['Serviette'] ?? 0);
    double totalDrapBain =
        (agent['drap_bain_quantite'] ?? 0) * (prixArticles['Drap bain'] ?? 0);
    double totalGelDouche =
        (agent['gel_douche_quantite'] ?? 0) * (prixArticles['Gel douche'] ?? 0);

    total += totalCalecons;
    total += totalChaussettes;
    total += totalMalliots;
    total += totalTshirt;
    total += totalTourDeCou;
    total += totalSavon;
    total += totalSavonnette;
    total += totalBonnet;
    total += totalSousGant;
    total += totalServiettes;
    total += totalDrapBain;
    total += totalGelDouche;

    print('Total final: ${agent['prenom']} à dépensé  $total');
    return total;
  }

  // Ajoutez cette fonction pour vérifier si l'agent dépasse le plafond
  bool depassePlafond(Map<String, dynamic> agent) {
    return calculerTotalAgent(agent) > plafond;
  }

  // Ajoutez cette fonction pour vérifier si on peut commander plus d'un article
  bool peutCommanderPlus(Map<String, dynamic> agent, String nomArticle) {
    double prixArticle = prixArticles[nomArticle] ?? 0;
    double totalActuel = calculerTotalAgent(agent);

    return (totalActuel + prixArticle) <= plafond;
  }

  // Ajoutez cette fonction pour obtenir le style du texte de quantité
  TextStyle getQuantityTextStyle(
      Map<String, dynamic> agent, String nomArticle) {
    if (depassePlafond(agent)) {
      return TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    } else if (peutCommanderPlus(agent, nomArticle)) {
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
                                      color: MaterialStateProperty.resolveWith<
                                          Color>((Set<MaterialState> states) {
                                        return depassePlafond(agent)
                                            ? Colors.red.withOpacity(0.3)
                                            : Colors.transparent;
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
                                                          SizedBox(
                                                            height: 10,
                                                          ),
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
                                                          SizedBox(
                                                            height: 10,
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
                        DataColumn(
                            label: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Savon de\nMarseille'),
                          ],
                        )),
                        DataColumn(label: Text('Savonnette\nMarseille')),
                        DataColumn(label: Text('Bonnet\nanti-froid')),
                        DataColumn(label: Text('Sous gant\nQté')),
                        DataColumn(label: Text('Serviettes\nQté')),
                        DataColumn(label: Text('Drap de bain\nQté')),
                        DataColumn(label: Text('Gel douche\nQté')),
                      ],
                      rows: listAgent
                              ?.map(
                                  (agent) => DataRow(
                                          color: MaterialStateProperty.all(
                                              Colors.transparent),
                                          cells: [
                                            // Caleçons
                                            DataCell(
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () => showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        // Important: Initialiser les valeurs locales avec les valeurs actuelles de l'agent
                                                        int localQuantite =
                                                            agent['calecons_quantite'] ??
                                                                1;
                                                        String localTaille =
                                                            agent['calecons_taille'] ??
                                                                'S';

                                                        return StatefulBuilder(
                                                          // Utiliser StatefulBuilder pour permettre les mises à jour d'état dans le Dialog
                                                          builder: (context,
                                                              setState) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Modification Caleçon'),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(agent[
                                                                          'nom']),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(agent[
                                                                          'prenom'])
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          'Quantité: '),
                                                                      ReusableDropdown(
                                                                        value:
                                                                            localQuantite,
                                                                        items:
                                                                            quantite,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            // Utiliser setState du StatefulBuilder
                                                                            localQuantite =
                                                                                value as int;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          'Taille: '),
                                                                      ReusableDropdown(
                                                                        value:
                                                                            localTaille,
                                                                        items:
                                                                            taille,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            // Utiliser setState du StatefulBuilder
                                                                            localTaille =
                                                                                value as String;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          // Mettre à jour Firestore avec les nouvelles valeurs
                                                                          _firestore
                                                                              .collection('user')
                                                                              .doc(agent['uid'])
                                                                              .update({
                                                                            'calecons_quantite':
                                                                                localQuantite,
                                                                            'calecons_taille':
                                                                                localTaille,
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Enregistrer',
                                                                          style:
                                                                              fontButton,
                                                                        ),
                                                                        style: ButtonStyle(
                                                                            backgroundColor:
                                                                                WidgetStatePropertyAll(Colors.green)),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child:
                                                                            Text(
                                                                          'Annuler',
                                                                          style:
                                                                              fontButton,
                                                                        ),
                                                                        style: ButtonStyle(
                                                                            backgroundColor:
                                                                                WidgetStatePropertyAll(Colors.red)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }),
                                                  child: Text(
                                                      '${agent['calecons_quantite'] ?? '0'} / ${agent['calecons_taille'] ?? 'S'}',
                                                      style:
                                                          getQuantityTextStyle(
                                                              agent,
                                                              'Caleçons')),
                                                ),
                                              ),
                                            ),
                                            // Chaussettes
                                            DataCell(
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      // Variables locales pour les chaussettes
                                                      int localQuantite = agent[
                                                              'chaussettes_quantite'] ??
                                                          1;
                                                      String localTaille = agent[
                                                              'chaussettes_taille'] ??
                                                          '39/42';

                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Modification Chaussettes'),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    '${agent['nom']} ${agent['prenom']}'),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Quantité: '),
                                                                    ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteChaussette,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Taille: '),
                                                                    ReusableDropdown(
                                                                      value:
                                                                          localTaille,
                                                                      items:
                                                                          taileChaussette,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localTaille =
                                                                              value as String;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
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
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'chaussettes_quantite':
                                                                              localQuantite,
                                                                          'chaussettes_taille':
                                                                              localTaille,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.green)),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.red)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  child: Text(
                                                      '${agent['chaussettes_quantite'] ?? '0'}   ${agent['chaussettes_taille'] ?? '39/42'}',
                                                      style:
                                                          getQuantityTextStyle(
                                                              agent,
                                                              'Chaussettes')),
                                                ),
                                              ),
                                            ),
                                            // Maillots
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'maillots_quantite'] ??
                                                          1;
                                                      String localTaille = agent[
                                                              'maillots_taille'] ??
                                                          'S';

                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Maillots'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(agent[
                                                                      'nom']),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(agent[
                                                                      'prenom']),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantite,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
                                                                        });
                                                                      })
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Taille: '),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localTaille,
                                                                      items:
                                                                          taille,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localTaille =
                                                                              value ?? 'S';
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'maillots_quantite':
                                                                              localQuantite,
                                                                          'maillots_taille':
                                                                              localTaille,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: WidgetStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: WidgetStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: (agent['maillots_quantite'] ??
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
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        (agent['maillots_quantite'] ??
                                                                '0')
                                                            .toString(),style: getQuantityTextStyle(agent, 'malliot'),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Text(agent[
                                                              'maillots_taille'] ??
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
                                                      int localQuantite = agent[
                                                              'tshirt_quantite'] ??
                                                          1;
                                                      String localTaille = agent[
                                                              'tshirt_taille'] ??
                                                          'S';

                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Modification T-shirt'),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    '${agent['nom']} ${agent['prenom']}'),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Quantité: '),
                                                                    ReusableDropdown(
                                                                        value:
                                                                            localQuantite,
                                                                        items:
                                                                            quantite,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            localQuantite =
                                                                                value as int;
                                                                          });
                                                                        }),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Taille: '),
                                                                    ReusableDropdown(
                                                                        value:
                                                                            localTaille,
                                                                        items:
                                                                            taille,
                                                                        onChanged:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            localTaille =
                                                                                value as String;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'tshirt_quantite':
                                                                              localQuantite,
                                                                          'tshirt_taille':
                                                                              localTaille,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.green)),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.red)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: (agent['tshirt_quantite'] ??
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
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        (agent['tshirt_quantite'] ??
                                                                '0')
                                                            .toString(),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(agent[
                                                              'tshirt_taille'] ??
                                                          '39/40'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                            // Tour de cou
                                            DataCell(
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'tourdecou2_quantite'] ??
                                                          1;

                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Modification Tour de cou'),
                                                            content: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                    '${agent['nom']} ${agent['prenom']}'),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        'Quantité: '),
                                                                    ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantite,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ],
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
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'tourdecou2_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.green)),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ),
                                                                      style: ButtonStyle(
                                                                          backgroundColor:
                                                                              WidgetStatePropertyAll(Colors.red)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  child: Text(
                                                    (agent['tourdecou2_quantite'] ??
                                                            '0')
                                                        .toString(),
                                                    style: getQuantityTextStyle(
                                                        agent, 'Tour de cou'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //////// Savon de Marseille
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'savon_marseille_quantite'] ??
                                                          12;

                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Savon de Marseille'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteSavons,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'savon_marseille_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['savon_marseille_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                            // Savonnette de Marseille
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'savonnette_marseille_quantite'] ??
                                                          12;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Savonnette de Marseille'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteSavons,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'savonnette_marseille_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['savonnette_marseille_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                            // Bonnet anti-froid
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'bonnet_quantite'] ??
                                                          1;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Bonnet anti-froid'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteBonnet,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'bonnet_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['bonnet_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                            // Sous gant
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'sous_gant_quantite'] ??
                                                          1;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Sous gant'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteSousGant,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'sous_gant_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['sous_gant_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                            // Serviettes
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'serviette_quantite'] ??
                                                          1;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Serviettes'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteServiette,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'serviette_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['serviette_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                            // Drap de bain
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'drap_bain_quantite'] ??
                                                          1;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Drap de bain'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteDrapBain,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'drap_bain_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['drap_bain_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
                                              ),
                                            )),
                                            // Gel douche
                                            DataCell(Center(
                                              child: GestureDetector(
                                                onTap: () => showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      int localQuantite = agent[
                                                              'gel_douche_quantite'] ??
                                                          1;
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Modification Gel douche'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  '${agent['nom']} ${agent['prenom']}'),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      'Quantité: '),
                                                                  ReusableDropdown(
                                                                      value:
                                                                          localQuantite,
                                                                      items:
                                                                          quantiteGelDouche,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          localQuantite =
                                                                              value as int;
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
                                                                      onPressed:
                                                                          () {
                                                                        _firestore
                                                                            .collection('user')
                                                                            .doc(agent['uid'])
                                                                            .update({
                                                                          'gel_douche_quantite':
                                                                              localQuantite,
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .green)),
                                                                      child:
                                                                          Text(
                                                                        'Enregistrer',
                                                                        style:
                                                                            fontButton,
                                                                      )),
                                                                  ElevatedButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors
                                                                              .red)),
                                                                      child:
                                                                          Text(
                                                                        'Annuler',
                                                                        style:
                                                                            fontButton,
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                child: Text(
                                                  (agent['gel_douche_quantite'] ??
                                                          '0')
                                                      .toString(),
                                                ),
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
