import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uli_doation/screens/adminSceen.dart';

import 'package:uli_doation/screens/login_screen.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

Stream<QuerySnapshot<Map<String, dynamic>>> checkAuth() {
  User? currentUser = _auth.currentUser;

  print('Utilisateur connecté $currentUser');

  if (currentUser?.email == 'jean@arcelormittal.com') {
    return _firestore
        .collection('user')
        .where('equipe', isEqualTo: 1)
        .where('secteur', isEqualTo: 'Amont Fer')
        .snapshots();
  } else if (currentUser?.email == 'manu.vdm@arcelormittal.com') {
    return _firestore
        .collection('user')
        .where('equipe', isEqualTo: 2)
        .where('secteur', isEqualTo: 'Amont Fer')
        .snapshots();
  } else if (currentUser?.email == '') {
    print('user not found');
  }
  print(_auth.currentUser?.email);
  // Par défaut, retourner une collection vide
  return _firestore.collection('user').snapshots();
}

updateCaleconInfo(String userId, String taille, int quantite) async {
  try {
    await _firestore
        .collection('user')
        .doc(userId)
        .update({'calecons taille': taille, 'calecons quantite': quantite});
    print('Updated successfully');
    print("l'identifiant de la paersonne est : $userId");
  } catch (e) {
    print('Error updating: $e');
    print("l'identifiant de la paersonne est : $userId");
  }
}

updateChaussettesInfo(String userId, String taille, int quantite) async {
  try {
    await _firestore.collection('user').doc(userId).update(
        {'chaussettes taille': taille, 'chaussettes quantite': quantite});
    print('Updated successfully');
    print("l'identifiant de la paersonne est : $userId");
  } catch (e) {
    print('Error updating: $e');
    print("l'identifiant de la paersonne est : $userId");
  }
}

updateMalliotsInfo(String userId, String taille, int quantite) async {
  try {
    await _firestore
        .collection('user')
        .doc(userId)
        .update({'maillots taille': taille, 'maillots quantite': quantite});
    print('Updated successfully');
    print("l'identifiant de la paersonne est : $userId");
  } catch (e) {
    print('Error updating: $e');
    print("l'identifiant de la paersonne est : $userId");
  }
}

updateTshirtInfo(String userId, String taille, int quantite) async {
  try {
    await _firestore
        .collection('user')
        .doc(userId)
        .update({'Tshirt taille': taille, 'Tshirt quantite': quantite});
    print('Updated successfully');
    print("l'identifiant de la paersonne est : $userId");
  } catch (e) {
    print('Error updating: $e');
    print("l'identifiant de la paersonne est : $userId");
  }
}

customAppBar(BuildContext context) {
  if (_auth.currentUser?.email == 'jean@arcelormittal.com') {
    return AppBar(
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
      title: Row(
        children: [
          Text('Equipe 1 - Amont Fer',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminScreen())),
          icon: Icon(
            Icons.admin_panel_settings,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            _auth.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ],
    );
  } else if (_auth.currentUser?.email == 'manu.vdm@arcelormittal.com') {
    return AppBar(
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
      title: Row(
        children: [
          Text('Equipe 2 - Amont Fer',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminScreen())),
          icon: Icon(
            Icons.admin_panel_settings,
            color: Colors.white,
          ),
        ),
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            _auth.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  } else {
    return AppBar(
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
      title: Row(
        children: [
          Text('Equipe 3 - Amont Fer',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            _auth.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }
}

Widget nombreTotalDeCalecon() {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('user').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text('Une erreur est survenue'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final totalCalecon = snapshot.data!.docs.fold<int>(0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return sum + (data['calecons quantite'] ?? 0) as int;
      });
      return Text(totalCalecon.toString());
    },
  );
}

Widget nombreTotalDeCaleconEquipe1() {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('user')
        .where('equipe', isEqualTo: 1)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text('Une erreur est survenue'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final totalCalecon = snapshot.data!.docs.fold<int>(0, (sum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return sum + (data['calecons quantite'] ?? 0) as int;
      });
      return Text(totalCalecon.toString());
    },
  );
}

detailCaleconEquipe1() {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('equipe', isEqualTo: 1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text('Chargement...');

        Map<String, int> totalParTaille = {};
        final docs = snapshot.data!.docs; // Get docs from snapshot

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>?;

          if (data == null) continue;

          String taille =
              data['calecons taille']?.toString() ?? 'Inconnu'; // Gérer `null`
          int quantite = (data['calecons quantite'] is int)
              ? data['calecons quantite']
              : int.tryParse(data['calecons quantite']?.toString() ?? '0') ??
                  0; // Gérer `null` et conversion

          if (quantite > 0) {
            totalParTaille[taille] = (totalParTaille[taille] ?? 0) + quantite;
            print('total par taillle: $totalParTaille');
          }
        }

        // Vérifier si on a des tailles valides
        if (totalParTaille.isEmpty) {
          return Center(child: Text("Aucun caleçon trouvé pour l'équipe 1"));
        }

        // Formater l'affichage des tailles
        String taillesStr = totalParTaille.entries
            .map((entry) => '${entry.key}:${entry.value}')
            .join(', ');

        return Center(
          child: Text(taillesStr),
        );
      });
}
