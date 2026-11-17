import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mvu_platform/dto/passkey.dart';
import 'package:mvu_platform/service/passkey_service.dart';
import 'package:mvu_platform/widget/navigation_drawer.dart';
import 'package:passkeys/types.dart';

class PasskeysPage extends StatefulWidget {
  const PasskeysPage({super.key});

  @override
  State<PasskeysPage> createState() => _PasskeysPageState();
}

class _PasskeysPageState extends State<PasskeysPage> {
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  late Future<List<Passkey>> futurePasskeys;

  @override
  void initState() {
    super.initState();
    futurePasskeys = getPasskeys();
  }

  void _reload() {
    setState(() {
      futurePasskeys = getPasskeys();
    });
  }

  Future<void> _add() async {
    try {
      await registerPasskey();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passkey wurde hinzugefügt')));
      }
      _reload();
    } on PasskeyAuthCancelledException {
      // dismissed by the user
    } on ExcludeCredentialsCanNotBeRegisteredException {
      _showError('Auf diesem Gerät ist bereits ein Passkey vorhanden');
    } catch (_) {
      _showError('Passkey konnte nicht hinzugefügt werden');
    }
  }

  Future<void> _delete(Passkey passkey) async {
    try {
      await deletePasskey(passkey.id);
      _reload();
    } catch (_) {
      _showError('Passkey konnte nicht gelöscht werden');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.redAccent, content: Text(message)));
    }
  }

  String _subtitle(Passkey passkey) {
    final created = 'erstellt am ${_dateFormat.format(passkey.createdAt)}';
    return passkey.lastUsedAt != null ? '$created, zuletzt verwendet am ${_dateFormat.format(passkey.lastUsedAt!)}' : created;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passkeys')),
      body: Container(
        padding: const .all(16),
        child: FutureBuilder(
          future: futurePasskeys,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  const Padding(
                    padding: .only(bottom: 16),
                    child: Text('Mit einem Passkey meldest du dich ohne Passwort an, z.B. mit Face ID oder Fingerabdruck.'),
                  ),
                  ...snapshot.requireData.map(
                    (passkey) => ListTile(
                      leading: const Icon(Icons.key),
                      title: Text(passkey.name),
                      subtitle: Text(_subtitle(passkey)),
                      trailing: IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Löschen', onPressed: () => _delete(passkey)),
                    ),
                  ),
                  Padding(
                    padding: const .only(top: 16),
                    child: OutlinedButton.icon(icon: const Icon(Icons.add), label: const Text('Passkey hinzufügen'), onPressed: _add),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      drawer: const MvuNavigationDrawer(),
    );
  }
}
