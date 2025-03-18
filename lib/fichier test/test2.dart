import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uli_doation/coponent/dropdown.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<Map<String, dynamic>> _users = [];

String user = '';
List<String> tailleChausette = ['S', 'M', 'L', 'XL', 'XXL'];
String selectedTailleChaussette = 'S';
List<int> quantiteChaussette = [1, 2, 3, 4, 5, 6];
int selectedQuantiteChaussette = 1;
List<String> tailleCalecon = ['S', 'M', 'L', 'XL', 'XXL'];
String selectedTailleCalecon = 'S';
List<int> quantiteCalecon = [1, 2, 3, 4, 5, 6];
int selectedQuantiteCalecon = 1;

final List<Map<String, dynamic>> articles = [
  {
    'name': 'chaussettes',
    'taille': ['S', 'M', 'L', 'XL', 'XXL'],
    'quantities': [1, 2, 3, 4, 5, 6],
  },
  {
    'name': 'caleçons',
    'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
    'quantities': [1, 2, 3, 4, 5, 6],
  },
  {
    'name': 'maillots',
    'sizes': ['XS', 'S', 'M', 'L', 'XL'],
    'quantities': [1, 2, 3, 4, 5],
  },
];


class _Test2State extends State<Test2> {
  int selectedQuantite = 0;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Liste des agents de l'equipe 2"),
              actions: [
                IconButton(onPressed: _auth.signOut, icon: Icon(Icons.login))
              ],
            ),
            body: StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 20,
                  columns: [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('Nom')),
                    DataColumn(label: Text('Prénom')),
                    DataColumn(label: Text('Equipe')),
                    DataColumn(label: Text('Chaussettes'))
                  ],
                  rows: _users
                      .map(
                        (user) => DataRow(cells: [
                          DataCell(IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Modifier les informations"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row( mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Expanded(child: Text("Nom : ${user['nom'] ?? 'Inconnu'}")),   Row(
                                            children: [
                                              Text("Équipe:"),
                                              SizedBox(width: 10),
                                              dropDownEquipe()
                                            ],
                                          ),
                                            ],
                                          ),
                                          Text(
                                              "Prénom : ${user['prenom'] ?? 'Inconnu'}"),
                                       
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                               Text('Calecons'),
                                               SizedBox(width: 10),
                                            
                                              
                                              SizedBox(width: 10),
                                              ReusableDropdown(value: selectedTailleCalecon, 
                                             items: taille, 
                                             onChanged: (value){
                                               setState(() {
                                                 selectedTailleChaussette = value ?? 'S';
                                               });
                                             }) ,
                                             ReusableDropdown(value: selectedQuantiteCalecon, items: tailleCalecon  , onChanged: (value){
                                               setState(() {
                                                 selectedQuantiteCalecon = value as int? ?? 1;
                                               });
                                             })
                                           
                                            ],
                                          ),
                                          Row(
                                             children: [
                                               Text('Chaussettes'),
                                               SizedBox(width: 10),
                                               ReusableDropdown(value: selectedQuantiteChaussette , items: quantiteChaussette, onChanged: (value){
                                                 setState(() {
                                                   selectedQuantiteChaussette = value  ?? 1;
                                                 });
                                               }),
                                               ReusableDropdown(value: selectedTailleChaussette, items: tailleChausette, onChanged: (value){
                                                 setState(() {
                                                   selectedTailleChaussette = value ?? 'S';
                                                 });
                                               })
                                             ],
                                          )
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  updateSocksInfo(
                                                      user['uid'], selectedTaille);
                                                  updateCaleconInfo(
                                                      user['uid'], selectedTaille);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            Colors.green)),
                                                child: Text('Valider')),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            Colors.red)),
                                                onPressed: null,
                                                child: Text('Anuler')),
                                          ],
                                        )
                                      ],
                                    );
                                  });
                              print('uid de utilisateur : ${user['uid']}');
                            },
                            icon: Icon(Icons.mode_edit_outline_outlined),
                          )),
                          DataCell(Text(user['nom'] ?? 'Inconnu')),
                          DataCell(Text(user['prenom'] ?? 'Inconnu')),
                          DataCell(Text(user['equipe'].toString())),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(user['chaussette taille'] ?? 'N/A'),
                              Text(user['chaussette quantite'].toString() ?? 'N/A')
                            ],
                          ))
                        ]),
                      )
                      .toList(),
                ));
              }
            )));
  }

  Future<void> checkAuth() async {
    late final User _curentUser;
// vérifie si l'utilisateur est connécté
    _auth.authStateChanges().listen((user) {
      if (user!.uid == 'dYBrthfyzkWLDMNJnuT9fBbhh6k2') {
        setState(() {
          _curentUser = user;
          print("l'utilisateur est :$_curentUser");
        });
        _fetchUsers1(_curentUser.toString());
      } else if (user.uid == 'olDxdzdxVwfIDybRlGLJYXRQ1Tl2') {
        setState(() {
          _curentUser = user;
        });
        _fetchUsers2(_curentUser.toString());
      }
    });
  }

  Future<void> _fetchUsers1(String userUid) async {
    try {
      final snapshot = await _firestore
          .collection('user')
          .where('equipe', isEqualTo: 1)
          .get();
      setState(() {
        _users = snapshot.docs.map((doc) {
          final data = doc.data(); // on récupérer toutes les données
          data['uid'] = doc.id; // ajoute l'id du document
          return data;
        }).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchUsers2(String userUid) async {
    try {
      final snapshot = await _firestore
          .collection('user')
          .where('equipe', isEqualTo: 2)
          .get();
      setState(() {
        _users = snapshot.docs!.map((doc) => doc.data()).toList();
        print(' utilisateur $_users');
      });
    } catch (e) {
      print(e);
    }
  }

// Modify updateCaleconInfo to handle null safely
  Future<void> updateCaleconInfo(String userId, String taille, ) async {
    try {
      await _firestore.collection('user').doc(userId).update({
        'calecon taille': selectedTaille,
        'calecon quantite': selectedQuantite
      });
      print('Updated successfully');
      print("l'identifiant de la paersonne est : $userId");
    } catch (e) {
      print('Error updating: $e');
      print("l'identifiant de la paersonne est : $userId");
    }
  }

  // Modify updateSocksInfo to handle null safely
  Future<void> updateSocksInfo(String userId, String taille) async {
    try {
      await _firestore.collection('user').doc(userId).update({
        'chaussette taille 2': selectedTaille,
        'chaussette quantite': selectedQuantite
      });
      print('Updated successfully');
    
    } catch (e) {
      print('Error updating: $e');
     
    }
  }

}
