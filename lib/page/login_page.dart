import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVU Login')),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    autofillHints: [AutofillHints.username],
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    autofillHints: [AutofillHints.password],
                  ),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      try {
                        await _firebaseAuth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                              'Login fehlgeschlagen: ${buildErrorMessage(e)}',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reset-password');
                      },
                      child: const Text('Passwort vergessen?'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String buildErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'unknown':
        {
          return 'Bitte Email und Passwort eingeben';
        }
      case 'invalid-email':
        {
          return 'ungültige Email';
        }
      case 'user-disabled':
        {
          return 'Login gesperrt';
        }
      case 'user-not-found':
        {
          return 'Email unbekannt';
        }
      case 'invalid-credential':
        {
          return 'Ungültiges Passwort';
        }
      case 'wrong-password':
        {
          return 'Falsches Passwort';
        }
      default:
        {
          return e.message ?? '';
        }
    }
  }
}
