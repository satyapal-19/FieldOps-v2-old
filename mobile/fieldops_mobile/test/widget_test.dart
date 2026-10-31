import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fieldops_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://test-project.example.invalid',
      // ignore: deprecated_member_use
      anonKey: 'test-anon-key',
    );
  });

  testWidgets('FieldOps app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FieldOpsApp());
    expect(find.byType(FieldOpsApp), findsOneWidget);
    // Allow splash timer to complete
    await tester.pump(const Duration(seconds: 3));
  });
}
