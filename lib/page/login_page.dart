import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mvu_platform/service/passkey_service.dart';
import 'package:passkeys/types.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const .all(16),
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: .stretch,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    autofillHints: const [AutofillHints.username, AutofillHints.email],
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Passwort'),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    autofillHints: const [AutofillHints.password],
                  ),
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: .circular(10))),
                    onPressed: () async {
                      try {
                        await _firebaseAuth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          showLoginError(context, 'Login fehlgeschlagen: ${buildErrorMessage(e)}');
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                  Padding(
                    padding: const .only(top: 24),
                    child: FilledButton.icon(
                      icon: const Icon(Icons.key),
                      label: const Text('Mit Passkey anmelden'),
                      onPressed: () async {
                        try {
                          await loginWithPasskey();
                        } on PasskeyAuthCancelledException {
                          // dismissed by the user
                        } on NoCredentialsAvailableException {
                          if (context.mounted) {
                            showLoginError(context, 'Kein Passkey vorhanden, bitte mit Passwort anmelden');
                          }
                        } catch (_) {
                          if (context.mounted) {
                            showLoginError(context, 'Login mit Passkey fehlgeschlagen');
                          }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const .only(top: 40),
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

  void showLoginError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent, content: Text(message)));
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
      case 'channel-error':
        {
          return 'Allgemeiner Fehler';
        }
      default:
        {
          return e.message ?? '';
        }
    }
  }
}
