import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bottom_nav_page.dart';
import 'find_events_page.dart';
import 'events_page.dart';
import 'ai_guide_page.dart';
import 'organizer_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'reset_password_page.dart';

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();

bool passwordRecoveryPending = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ypqivhnyyewndrgtfwoc.supabase.co',
    publishableKey:
    'sb_publishable_XMt41csuBw56sCZAet5h5Q_CAIICztB',
  );

  // Listen BEFORE runApp().
  //
  // This is important because the recovery event can happen
  // while Supabase is processing the deep link.
  Supabase.instance.client.auth.onAuthStateChange.listen(
        (data) {
      debugPrint('AUTH EVENT: ${data.event}');

      if (data.event == AuthChangeEvent.passwordRecovery) {
        debugPrint('PASSWORD RECOVERY DETECTED');

        passwordRecoveryPending = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final navigator = navigatorKey.currentState;

          if (navigator == null) return;

          navigator.push(
            MaterialPageRoute(
              builder: (_) => const ResetPasswordPage(),
            ),
          );
        });
      }
    },
    onError: (error, stackTrace) {
      debugPrint('AUTH ERROR: $error');
    },
  );

  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,

      title: 'CampusConnect',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
        const Color(0xFF151B34),
        primaryColor:
        const Color(0xFF6C63FF),
        fontFamily: 'Poppins',
      ),

      home: const AuthHandler(),

      routes: {
        '/find-events': (context) =>
        const FindEventsPage(),

        '/events': (context) =>
        const EventsPage(),

        '/ai-guide': (context) =>
        const AIGuidePage(),

        '/organizer': (context) =>
        const OrganizerPage(),

        '/login': (context) =>
        const LoginPage(),

        '/signup': (context) =>
        const SignupPage(),

        '/reset-password': (context) =>
        const ResetPasswordPage(),
      },
    );
  }
}

class AuthHandler extends StatefulWidget {
  const AuthHandler({super.key});

  @override
  State<AuthHandler> createState() =>
      _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  @override
  void initState() {
    super.initState();

    // If the recovery event was detected before
    // the Flutter UI finished loading, open the
    // reset password page now.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (passwordRecoveryPending) {
        passwordRecoveryPending = false;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ResetPasswordPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        Supabase.instance.client.auth.currentUser;

    if (user != null) {
      return const BottomNavPage();
    }

    return const LoginPage();
  }
}