import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passwort wiederherstellen')), // use Builder so we can provide a new scope context
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                    controller: _emailController,
                  ),
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Wiederherstellen'),
                    onPressed: () async {
                      try {
                        await _firebaseAuth.sendPasswordResetEmail(email: _emailController.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Email wurde an ${_emailController.text} verschickt')));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(backgroundColor: Colors.redAccent, content: Text('Problem: ${buildErrorMessage(e)}')));
                        }
                      }
                    },
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
          return 'Bitte Email eingeben';
        }
      case 'invalid-email':
        {
          return 'ungültige Email';
        }
      case 'user-not-found':
        {
          return 'Unbekannte Email';
        }
      case 'channel-error':
        {
          return 'Channel Error';
        }
      default:
        {
          return e.message ?? '';
        }
    }
  }
}
