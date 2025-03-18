import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAgentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agents de l'équipe 1")),
      body: FutureBuilder<User?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Aucun utilisateur connecté"));
          }

          final currentUser = snapshot.data!;
          return FutureBuilder<int?>(
            future: _getTeamForSupervisor(currentUser.email!),
            builder: (context, teamSnapshot) {
              if (teamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (teamSnapshot.hasError) {
                return Center(child: Text("Erreur : ${teamSnapshot.error}"));
              } else if (!teamSnapshot.hasData || teamSnapshot.data != 1) {
                return Center(child: Text("Vous n'êtes pas autorisé à afficher les agents de l'équipe 1"));
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .where('equipe', isEqualTo: 1)
                    .where('role', isEqualTo: 'agent')
                    .snapshots(),
                builder: (context, agentSnapshot) {
                  if (agentSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (agentSnapshot.hasError) {
                    return Center(child: Text("Erreur : ${agentSnapshot.error}"));
                  } /* else if (!agentSnapshot.hasData || agentSnapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Aucun agent trouvé dans l'équipe 1"));
                  } */

                  final agents = agentSnapshot.data!.docs;

                  return ListView.builder(
                    itemCount: agents.length,
                    itemBuilder: (context, index) {
                      final agent = agents[index];
                      final nom = agent['nom'] ?? 'Nom inconnu';
                      final prenom = agent['prenom'] ?? 'Prénom inconnu';

                      return ListTile(
                        title: Text('$prenom $nom'),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<int?> _getTeamForSupervisor(String email) async {
    final supervisorSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .where('role', isEqualTo: 'manager')
        .get();

    if (supervisorSnapshot.docs.isNotEmpty) {
      return supervisorSnapshot.docs.first['equipe'];
    }
    return null;
  }
}

