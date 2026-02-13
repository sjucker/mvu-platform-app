import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvu_platform/dto/repertoire.dart';
import 'package:mvu_platform/page/absenzen_page.dart';
import 'package:mvu_platform/page/change_password_page.dart';
import 'package:mvu_platform/page/konzert_detail_page.dart';
import 'package:mvu_platform/page/konzerte_page.dart';
import 'package:mvu_platform/page/login_page.dart';
import 'package:mvu_platform/page/repertoire_detail_page.dart';
import 'package:mvu_platform/page/repertoire_page.dart';
import 'package:mvu_platform/page/reset_password_page.dart';

class StreamAuthNotifier extends ChangeNotifier {
  StreamAuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }
}

final router = GoRouter(
  refreshListenable: StreamAuthNotifier(),
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/konzerte', builder: (context, state) => const KonzertePage()),
    GoRoute(
      path: '/konzert-detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return KonzertDetailPage(id: id);
      },
    ),
    GoRoute(path: '/repertoire', builder: (context, state) => const RepertoirePage()),
    GoRoute(
      path: '/repertoire-detail/:repertoireType',
      builder: (context, state) {
        final repertoireType = RepertoireType.values.byName(state.pathParameters['repertoireType']!);
        return RepertoireDetailPage(repertoireType: repertoireType);
      },
    ),
    GoRoute(path: '/absenzen', builder: (context, state) => const AbsenzenPage()),
    GoRoute(path: '/change-password', builder: (context, state) => const ChangePasswordPage()),
    GoRoute(path: '/reset-password', builder: (context, state) => const ResetPasswordPage()),
  ],
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final onLoginPage = state.matchedLocation == '/login';
    final onResetPasswordPage = state.matchedLocation == '/reset-password';

    if (user == null && !onLoginPage && !onResetPasswordPage) {
      return '/login';
    }
    if (user != null && onLoginPage) {
      return '/absenzen';
    }

    return null;
  },
);
