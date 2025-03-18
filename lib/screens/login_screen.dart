import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController email_controller = TextEditingController();
TextEditingController password_controller = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final witdth=MediaQuery.of(context).size.width/3;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Placeholder(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    child: Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: witdth,
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo_arcelorMittal_blanc.png'),
                        SizedBox(height: 30),
                        Text('ULI DOTATION',style: TextStyle(color: Colors.white, fontSize: 20),),
                         SizedBox(height: 30),
                        Text('CONNEXION',style: TextStyle(color: Colors.white, fontSize: 15),),
                     SizedBox(height: 30),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: email_controller,
                          decoration: InputDecoration(
                              labelText: 'User Name',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(Icons.email_rounded,color: Colors.white,),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: password_controller,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.lock,color: Colors.white,),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => loginToFirebase(),
                        child: Container(
                          width: witdth,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xfffea753),
                               Color(0xfffb7045),
                              Color(0xffed2b49),
                            Color(0xffc01271),
                            ],
                            begin:Alignment.centerLeft,
                            end: Alignment.centerRight),
                         borderRadius: BorderRadius.circular(10) ),
                          child: Center(
                            child: Text('Se connecter',style: TextStyle(color: Colors.white,
                            fontSize: 20),),
                          ),
                        ),
                      )
                      

                       
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginToFirebase() {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email_controller.text.trim(),
          password: password_controller.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Aucun utilisateur trouvé pour cet e-mail.');
      } else if (e.code == 'Wrong-passord') {
        print('Mot de passe incorect');
      }
    }
  }
}
