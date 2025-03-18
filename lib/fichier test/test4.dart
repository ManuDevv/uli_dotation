import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final bdd = FirebaseFirestore.instance;

class TableteamScreen extends StatefulWidget {
  const TableteamScreen({super.key});

  @override
  State<TableteamScreen> createState() => _TableteamScreenState();
}

class _TableteamScreenState extends State<TableteamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Test'),
          Center(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Equipe 1').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Erreur de récupération des données'),
                );
              } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text('Aucune donnée disponible'),
                );
              }
      
              // Récupérer les documents
              final data = snapshot.data.docs;
      
              return Container(
                color: Colors.blue,
                width: 400,
                height: 400,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // Récupérer chaque document
                    final document = data[index];
                    final text = document[
                        'nom']; // Assurez-vous que 'nom' est un champ valide dans Firestore
                    print(text);
                    return ListTile(
                      title: Text(text),
                    );
                  },
                ),
              );
            },
          )),
        ],
      ),
    );
    ;
  }
}
