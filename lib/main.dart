import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/data/local/hive_registrar.dart';
import 'package:pinterest_clone/core/theme/theme_config.dart';
import 'package:pinterest_clone/core/router/router_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  ThemeConfig.initialize();

  await HiveRegistrar.init();

  runApp(
    ClerkAuth(
      config: ClerkAuthConfig(
        publishableKey: dotenv.env['CLERK_PUBLISHABLE_KEY']!,
      ),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pinterest Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeConfig.defaultThemeMode,
      routerConfig: createRouter(context),
    );
  }
}
