import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realstateclient/controllers/auth_controller.dart';
import 'package:realstateclient/core/secrets/secrets.dart';
import 'package:realstateclient/core/themes/app_themes.dart';
import 'package:realstateclient/core/widgets/error_text.dart';
import 'package:realstateclient/core/widgets/loader.dart';
import 'package:realstateclient/firebase_options.dart';
import 'package:realstateclient/models/user_model.dart';
import 'package:realstateclient/router.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
      anonKey: AppSecrets.supabaseKey, url: AppSecrets.supabaseUrl);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? user;

  void getUserData(WidgetRef ref, auth.User data) async {
    user = await ref
        .watch(authControllProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
        data: (data) {
          return MaterialApp.router(
            title: "Real State Client",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkThemeMode,
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if (data != null) {
                getUserData(ref, data);
                if (user != null) {
                  return loggedInRoute;
                }
              }

              return loggedOutRoute;
            }),
            routeInformationParser: const RoutemasterParser(),
          );
        },
        error: (e, s) => ErrorText(text: e.toString()),
        loading: () => const Loader());
  }
}
