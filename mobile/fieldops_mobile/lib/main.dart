import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_failure.dart';
import 'core/api/api_service.dart';
import 'core/api/env.dart';
import 'core/outbox/outbox_service.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/bindings/initial_binding.dart';
import 'core/services/location_ping_service.dart';
import 'core/localization/app_translations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Server address comes only from --dart-define=API_BASE_URL=... (no URLs in source).
  if (!Env.isConfigured) {
    debugPrint('API_BASE_URL is not set: pass --dart-define=API_BASE_URL=https://<server>');
  }
  await ErrorMessages.load();
  Get.put(ApiService(), permanent: true);
  Get.put(await OutboxService.open(), permanent: true);

  // Background pings and outbox sync. Some emulators lack Workmanager; the
  // foreground timer and the outbox's own retries still work without it.
  try {
    await Workmanager().initialize(workmanagerCallbackDispatcher);
    await LocationPingService().registerOutboxSync();
  } catch (e) {
    debugPrint('Workmanager init note (non-critical): $e');
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
