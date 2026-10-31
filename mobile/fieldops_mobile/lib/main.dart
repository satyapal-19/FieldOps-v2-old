import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/bindings/initial_binding.dart';
import 'core/services/location_ping_service.dart';
import 'core/localization/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase initialization (legacy, removed in Phase 3) ──────
  // Pass values with --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  // No keys in source code (SMKC security rule).
  await Supabase.initialize(
    url: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: '',
    ),
    // ignore: deprecated_member_use
    anonKey: const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: '',
    ),
  );

  // ── Workmanager (background GPS + offline sync) ───────────────
  // Wrapped in try/catch — workmanager can fail on some emulators/test devices
  try {
    await Workmanager().initialize(workmanagerCallbackDispatcher);

    // Register background offline-sync task (runs every 30 min when connected)
    await LocationPingService().registerOfflineSync();
  } catch (e) {
    debugPrint('Workmanager init note (non-critical): $e');
    // App continues to function without background tasks
  }

  String savedLang = 'mr';
  try {
    final prefs = await SharedPreferences.getInstance();
    savedLang = prefs.getString('selected_locale_code') ?? 'mr';
  } catch (e) {
    debugPrint('Prefs load note: $e');
  }

  runApp(FieldOpsApp(initialLang: savedLang));
}

class FieldOpsApp extends StatelessWidget {
  final String initialLang;
  const FieldOpsApp({super.key, this.initialLang = 'mr'});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FieldOps SMKMC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      translations: AppTranslations(),
      locale: Locale(initialLang, 'IN'),
      fallbackLocale: const Locale('en', 'IN'),
      // Global snackbar settings
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
