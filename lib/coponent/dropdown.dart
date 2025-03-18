import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class dropDownQuantite extends StatefulWidget {
  dropDownQuantite({super.key});

  @override
  State<dropDownQuantite> createState() => _dropDownQuantiteState();
}

List<int> quantite = [1, 2, 3, 4, 5, 6];
final List<Map<String, dynamic>> articles = [
  {
    'name': 'chaussettes',
    'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
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

class _dropDownQuantiteState extends State<dropDownQuantite> {
  static int selectedQuantite =
      1; // Rendu statique pour être accessible globalement

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedQuantite,
      items: quantite.map((int option) {
        return DropdownMenuItem<int>(
          value: option,
          child: Text(option.toString()),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedQuantite = newValue!;
          // Mettre à jour Firestore ici
          FirebaseFirestore.instance.collection('user').doc('USER_ID').update({
            'quantite': selectedQuantite,
          });
        });
      },
    );
  }
}

class dropDownTaille extends StatefulWidget {
  dropDownTaille({super.key});

  @override
  State<dropDownTaille> createState() => _dropDownTailleState();
}

List<String> taille = ['S', 'M', 'L', 'XL', 'XXL'];
String selectedTaille = 'S';

class _dropDownTailleState extends State<dropDownTaille> {
  static String selectedTaille =
      'S'; // Rendu statique pour être accessible globalement

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedTaille,
      items: taille.map((newTaille) {
        return DropdownMenuItem<String>(
          value: newTaille,
          child: Text(newTaille),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedTaille = newValue!;
          // Mettre à jour Firestore ici
          FirebaseFirestore.instance.collection('user').doc('USER_ID').update({
            'taille': selectedTaille,
          });
        });
      },
    );
  }
}
// Dropdown pour le changement equipe

class dropDownEquipe extends StatefulWidget {
  dropDownEquipe({super.key});

  @override
  State<dropDownEquipe> createState() => _dropDownEquipeState();
}

List equipe = ['1', '2', '3', '4', '5'];

class _dropDownEquipeState extends State<dropDownEquipe> {
  String selectedEquipe = '1';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedEquipe,
      items: equipe.map((newEquipe) {
        return DropdownMenuItem<String>(
          value: newEquipe,
          child: Text(newEquipe),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedEquipe = newValue!;
          print('Equipe : $selectedEquipe');
        });
      },
    );
  }
}

// test

class ReusableDropdown<T> extends StatelessWidget {
  final T value; // Valeur sélectionnée
  final List<T> items; // Liste des options
  final ValueChanged<T?>?
      onChanged; // Callback lorsqu'un élément est sélectionné
  final String hint; // Texte d'indication

  const ReusableDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = '',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      hint: Text(hint),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

// autre droptdown

class ArticleDropdown extends StatefulWidget {
  final String articleName;
  final List<String> sizes;
  final List<int> quantities;
  final String userId; // ID de l'utilisateur à mettre à jour

  const ArticleDropdown({
    super.key,
    required this.articleName,
    required this.sizes,
    required this.quantities,
    required this.userId,
  });

  @override
  State<ArticleDropdown> createState() => _ArticleDropdownState();
}

class _ArticleDropdownState extends State<ArticleDropdown> {
  String? selectedSize;
  int? selectedQuantity;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          selectedSize =
              userData['${widget.articleName}_taille'] ?? widget.sizes.first;
          selectedQuantity = userData['${widget.articleName}_quantite'] ??
              widget.quantities.first;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.articleName.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('Taille: '),
                ReusableDropdown<String>(
                  value: selectedSize ?? widget.sizes.first,
                  items: widget.sizes,
                  hint: 'Choisir une taille',
                  onChanged: (value) async {
                    setState(() {
                      selectedSize = value!;
                    });
                    await updateFirestore();
                  },
                ),
                SizedBox(width: 20),
                Text('Quantité: '),
                ReusableDropdown<int>(
                  value: selectedQuantity ?? widget.quantities.first,
                  items: widget.quantities,
                  hint: 'Choisir une quantité',
                  onChanged: (value) async {
                    setState(() {
                      selectedQuantity = value!;
                    });
                    await updateFirestore();
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: updateFirestore,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Valider ${widget.articleName}'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .update({
        '${widget.articleName}_taille': selectedSize,
        '${widget.articleName}_quantite': selectedQuantity,
      });
      print(
          '${widget.articleName} mis à jour : Taille = $selectedSize, Quantité = $selectedQuantity');
    } catch (e) {
      print('Erreur de mise à jour : $e');
    }
  }
}
