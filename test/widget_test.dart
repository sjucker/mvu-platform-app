import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvu_platform/main.dart';
import 'package:mvu_platform/page/login_page.dart';
import 'package:mvu_platform/service/dark_theme.dart';
import 'package:provider/provider.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseCoreMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');
  channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initialize') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': '123',
            'appId': '1:1234567890:web:abc',
            'messagingSenderId': '1234567890',
            'projectId': 'test',
          },
          'pluginConstants': {},
        }
      ];
    }
    return null;
  });
}


void main() {
  setupFirebaseCoreMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('App starts with LoginPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(false),
        child: const MvuApp(),
      ),
    );
    await tester.pumpAndSettle();
    // Verify that the LoginPage is displayed.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
