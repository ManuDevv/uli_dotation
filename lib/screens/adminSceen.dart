import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  double plafond = 160; // Valeur par défaut

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    _loadPlafond(); // Appeler la méthode pour charger le plafond
    // _loadPrixArticles();
    // _loadTotalCalecons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xfffea753),
                Color(0xfffb7045),
                Color(0xffed2b49),
                Color(0xffc01271),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text('Administration', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Synthèse Équipes'),
            Tab(text: 'Gestion Articles'),
            Tab(text: 'Synthèse Secteurs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSyntheseEquipes(),
          _buildGestionArticles(),
          _buildSyntheseSecteurs(),
        ],
      ),
    );
  }

  Widget _buildSyntheseEquipes() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('articles').snapshots(),
        builder: (context, articlesSnapshot) {
          if (articlesSnapshot.hasError) {
            return const Center(child: Text('Une erreur est survenue'));
          }

          if (articlesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final prixUnitaires = Map<String, double>.fromEntries(
            articlesSnapshot.data?.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return MapEntry(
                      data['nom'] ?? '', (data['prix'] ?? 0).toDouble());
                }) ??
                [],
          );
          // print(prixUnitaires);
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('user').snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasError) {
                return const Center(child: Text('Une erreur est survenue'));
              }

              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final commandes = userSnapshot.data?.docs ?? [];
              final equipesData = _processData(commandes);
              //   print(equipesData);
// equipe data ca récupére tout
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var equipe in equipesData.keys)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Équipe $equipe',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Article')),
                                DataColumn(label: Text('Quantité')),
                                DataColumn(label: Text('Tailles')),
                                DataColumn(label: Text('Total')),
                              ],
                              rows: _buildEquipeRows(
                                  equipesData[equipe]!, prixUnitaires),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGestionArticles() {
    return Column(
      children: [
        // Section Plafond
        Card(
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plafond par utilisateur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('parametres')
                      .doc('plafond')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    final plafondController = TextEditingController(
                      text: ((snapshot.data?.data()
                                  as Map<String, dynamic>)?['montant'] ??
                              160)
                          .toString(),
                    );

                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: plafondController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Montant en €',
                              suffixIcon: Icon(Icons.euro),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            double? nouveauPlafond =
                                double.tryParse(plafondController.text);
                            if (nouveauPlafond != null) {
                              _firestore
                                  .collection('parametres')
                                  .doc('plafond')
                                  .set({
                                'montant': nouveauPlafond,
                                'derniere_modification': DateTime.now(),
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Plafond mis à jour')),
                              );
                            }
                          },
                          child: Text('Enregistrer'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // Liste des articles (code existant)
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('articles').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Erreur de chargement'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final articles = snapshot.data?.docs ?? [];

              return ListView.builder(
                itemCount: articles.length + 1, // +1 pour le bouton d'ajout
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: Icon(Icons.add_circle, color: Colors.green),
                      title: Text('Ajouter un article'),
                      onTap: () => _showAddArticleDialog(context),
                    );
                  }

                  final article =
                      articles[index - 1].data() as Map<String, dynamic>;
                  final articleId = articles[index - 1].id;

                  return ListTile(
                    title: Text(article['nom'] ?? ''),
                    subtitle: Text('${article['prix']}€'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditArticleDialog(
                              context, articleId, article),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteArticle(articleId),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showAddArticleDialog(BuildContext context) async {
    final nomController = TextEditingController();
    final prixController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un article'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom de l\'article'),
            ),
            TextField(
              controller: prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore.collection('articles').add({
                'nom': nomController.text,
                'prix': double.tryParse(prixController.text) ?? 0,
              });
              Navigator.pop(context);
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditArticleDialog(BuildContext context, String articleId,
      Map<String, dynamic> article) async {
    final nomController = TextEditingController(text: article['nom']);
    final prixController =
        TextEditingController(text: article['prix'].toString());

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier l\'article'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom de l\'article'),
            ),
            TextField(
              controller: prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore.collection('articles').doc(articleId).update({
                'nom': nomController.text,
                'prix': double.tryParse(prixController.text) ?? 0,
              });
              Navigator.pop(context);
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteArticle(String articleId) async {
    await _firestore.collection('articles').doc(articleId).delete();
  }

  Map<String, Map<String, Map<String, int>>> _processData(
      List<QueryDocumentSnapshot> commandes) {
    Map<String, Map<String, Map<String, int>>> equipesData = {};

    print('Nombre total de documents: ${commandes.length}');

    for (var doc in commandes) {
      final data = doc.data() as Map<String, dynamic>;
      String equipeNum = data['equipe'].toString();
      String secteur = data['secteur'] ?? '';
      String equipe = "$equipeNum $secteur";

      if (!equipesData.containsKey(equipe)) {
        equipesData[equipe] = {
          'Caleçons': {
            'S': 0,
            'M': 0,
            'L': 0,
            'XL': 0,
            'XXL': 0,
          },
          'Chaussettes': {
            'S': 0,
            'M': 0,
            'L': 0,
            'XL': 0,
            'XXL': 0,
          },
          'Maillots': {
            'S': 0,
            'M': 0,
            'L': 0,
            'XL': 0,
            'XXL': 0,
          },
          'T-shirt': {
            'S': 0,
            'M': 0,
            'L': 0,
            'XL': 0,
            'XXL': 0,
          },
          'Tour de cou': {'Unique': 0},
          'Savon': {'Unique': 0},
          'Savonnette': {'Unique': 0},
          'Bonnet': {'Unique': 0},
          'Sous gant': {'Unique': 0},
          'Serviette': {'Unique': 0},
          'Drap de bain': {'Unique': 0},
          'Gel douche': {'Unique': 0},
        };
      }

      // Traitement des articles avec tailles
      if (data['calecons taille'] != null &&
          data['calecons taille'].toString().isNotEmpty) {
        String taille = data['calecons taille'].toString();
        int quantite = (data['calecons quantite'] ?? 0).toInt();
        equipesData[equipe]!['Caleçons']![taille] =
            (equipesData[equipe]!['Caleçons']![taille] ?? 0) + quantite;
        print(equipesData);
      }

      if (data['chaussettes taille'] != null &&
          data['chaussettes taille'].toString().isNotEmpty) {
        String taille = data['chaussettes taille'].toString();
        int quantite = (data['chaussettes quantite'] ?? 1).toInt();
        equipesData[equipe]!['Chaussettes']![taille] =
            (equipesData[equipe]!['Chaussettes']![taille] ?? 0) + quantite;
      }

      if (data['maillots taille'] != null &&
          data['maillots taille'].toString().isNotEmpty) {
        String taille = data['maillots taille'].toString();
        int quantite = (data['maillots quantite'] ?? 1).toInt();
        equipesData[equipe]!['Maillots']![taille] =
            (equipesData[equipe]!['Maillots']![taille] ?? 0) + quantite;
      }

      if (data['Tshirt taille'] != null &&
          data['Tshirt taille'].toString().isNotEmpty) {
        String taille = data['Tshirt taille'].toString();
        int quantite = (data['Tshirt quantite'] ?? 1).toInt();
        equipesData[equipe]!['T-shirt']![taille] =
            (equipesData[equipe]!['T-shirt']![taille] ?? 0) + quantite;
      }

      // Traitement des articles sans taille
      if (data['tourdecou2_quantite'] != null) {
        int quantite = (data['tourdecou2_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Tour de cou']!['Unique'] =
            (equipesData[equipe]!['Tour de cou']!['Unique'] ?? 0) + quantite;
      }

      if (data['savon_marseille_quantite'] != null) {
        int quantite = (data['savon_marseille_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Savon']!['Unique'] =
            (equipesData[equipe]!['Savon']!['Unique'] ?? 0) + quantite;
      }

      if (data['savonnette_marseille_quantite'] != null) {
        int quantite = (data['savonnette_marseille_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Savonnette']!['Unique'] =
            (equipesData[equipe]!['Savonnette']!['Unique'] ?? 0) + quantite;
      }

      if (data['bonnet_quantite'] != null) {
        int quantite = (data['bonnet_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Bonnet']!['Unique'] =
            (equipesData[equipe]!['Bonnet']!['Unique'] ?? 0) + quantite;
      }

      if (data['sous_gant_quantite'] != null) {
        int quantite = (data['sous_gant_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Sous gant']!['Unique'] =
            (equipesData[equipe]!['Sous gant']!['Unique'] ?? 0) + quantite;
      }

      if (data['serviette_quantite'] != null) {
        int quantite = (data['serviette_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Serviette']!['Unique'] =
            (equipesData[equipe]!['Serviette']!['Unique'] ?? 0) + quantite;
      }

      if (data['drap_bain_quantite'] != null) {
        int quantite = (data['drap_bain_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Drap de bain']!['Unique'] =
            (equipesData[equipe]!['Drap de bain']!['Unique'] ?? 0) + quantite;
      }

      if (data['gel_douche_quantite'] != null) {
        int quantite = (data['gel_douche_quantite'] ?? 1).toInt();
        equipesData[equipe]!['Gel douche']!['Unique'] =
            (equipesData[equipe]!['Gel douche']!['Unique'] ?? 0) + quantite;
      }
    }

    return equipesData;
  }

  List<DataRow> _buildEquipeRows(
    Map<String, Map<String, int>> equipeData,
    Map<String, double> prixUnitaires,
  ) {
    List<DataRow> rows = [];

    equipeData.forEach((article, tailles) {
      int quantiteTotale = tailles.values.fold(0, (sum, count) => sum + count);

      // Ne garder que les tailles avec une quantité > 0
      List<Widget> taillesWidgets = tailles.entries
          .where((entry) => entry.value > 0) // Filtre les quantités > 0
          .map((entry) => Text(entry.key == 'Unique'
              ? entry.value.toString()
              : '${entry.key}: ${entry.value}'))
          .toList();

      double prixUnitaire = prixUnitaires[article] ?? 0.0;
      double totalEuros = prixUnitaire * quantiteTotale;

      rows.add(
        DataRow(cells: [
          DataCell(Text(article)),
          DataCell(Text(quantiteTotale.toString())),
          DataCell(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: taillesWidgets,
          )),
          DataCell(Text('${totalEuros.toStringAsFixed(2)}€')),
        ]),
      );
    });

    // Ligne de total
    if (rows.isNotEmpty) {
      double totalEquipe = rows.fold(0.0, (sum, row) {
        String totalStr = (row.cells.last.child as Text).data ?? '0€';
        return sum + double.parse(totalStr.replaceAll('€', ''));
      });

      rows.add(
        DataRow(
          cells: [
            const DataCell(
                Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
            const DataCell(Text('')),
            const DataCell(Text('')),
            DataCell(Text(
              '${totalEquipe.toStringAsFixed(2)}€',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
        ),
      );
    }

    return rows;
  }

  Widget _buildSyntheseSecteurs() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('articles').snapshots(),
        builder: (context, articlesSnapshot) {
          if (articlesSnapshot.hasError) {
            return const Center(child: Text('Une erreur est survenue'));
          }

          if (articlesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final prixUnitaires = Map<String, double>.fromEntries(
            articlesSnapshot.data?.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return MapEntry(
                      data['nom'] ?? '', (data['prix'] ?? 0).toDouble());
                }) ??
                [],
          );

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('user').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Modifier la structure des données par secteur pour inclure les tailles
              Map<String, Map<String, Map<String, int>>> secteurData = {
                'Amont Fer': {},
                'Aval Fer': {},
                'Amont Parc': {},
                'Aval Parc': {},
              };

              // Dans la boucle de traitement
              for (var doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final secteur = data['secteur'] as String? ?? 'Non défini';

                // Initialiser la structure pour chaque article si nécessaire
                void initArticle(String article) {
                  if (!secteurData[secteur]!.containsKey(article)) {
                    secteurData[secteur]![article] = {
                      'S': 0,
                      'M': 0,
                      'L': 0,
                      'XL': 0,
                      'XXL': 0,
                      'Unique': 0,
                    };
                  }
                }

                // Traiter les articles avec tailles
                if (data['calecons taille'] != null) {
                  initArticle('Caleçons');
                  String taille = data['calecons taille'].toString();
                  int quantite = data['calecons quantite'] ?? 0;
                  secteurData[secteur]!['Caleçons']![taille] =
                      (secteurData[secteur]!['Caleçons']![taille] ?? 0) +
                          quantite;
                }

                if (data['chaussettes taille'] != null) {
                  initArticle('Chaussettes');
                  String taille = data['chaussettes taille'].toString();
                  int quantite = data['chaussettes quantite'] ?? 0;
                  secteurData[secteur]!['Chaussettes']![taille] =
                      (secteurData[secteur]!['Chaussettes']![taille] ?? 0) +
                          quantite;
                }

                // Articles sans taille
                void addArticleSansTaille(String article, String field) {
                  initArticle(article);
                  int quantite = data[field] ?? 0;
                  secteurData[secteur]![article]!['Unique'] =
                      (secteurData[secteur]![article]!['Unique'] ?? 0) +
                          quantite;
                }

                addArticleSansTaille('Tour de cou', 'tourdecou2_quantite');
                addArticleSansTaille('Savon', 'savon_marseille_quantite');
                addArticleSansTaille('Gel douche', 'gel_douche_quantite');
                // Ajouter les autres articles...
              }

              // Modifier l'affichage pour montrer les tailles
              return Column(
                children: secteurData.entries.map((secteur) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            secteur.key,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Article')),
                            DataColumn(label: Text('Détail Tailles')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Prix')),
                          ],
                          rows: secteur.value.entries.map((article) {
                            // Calculer le total des quantités
                            int totalQuantite = article.value.values
                                .fold(0, (sum, q) => sum + q);
                            double prix = prixUnitaires[article.key] ?? 0;
                            double totalPrix = totalQuantite * prix;

                            // Formater les tailles
                            String taillesDetail = article.value.entries
                                .where((e) => e.value > 0)
                                .map((e) => '${e.key}: ${e.value}')
                                .join('\n');

                            return DataRow(cells: [
                              DataCell(Text(article.key)),
                              DataCell(Text(taillesDetail)),
                              DataCell(Text(totalQuantite.toString())),
                              DataCell(
                                  Text('${totalPrix.toStringAsFixed(2)}€')),
                            ]);
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Future _loadPlafond() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('parametres').doc('plafond').get();
      if (snapshot.exists) {
        setState(() {
          plafond = (snapshot.data() as Map<String, dynamic>)['montant'] ?? 160;
        });
      }
      return plafond;
    } catch (e) {
      print('Erreur lors du chargement du plafond: $e');
    }
  }
}
