import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_islamic_widget/widgets/mercy_register_hero_card.dart';

void main() {
  testWidgets('MercyRegisterHeroCard renders properly with complete interaction cycle',
      (WidgetTester tester) async {
    // Provide sufficient screen size
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: MercyRegisterHeroCard(),
            ),
          ),
        ),
      ),
    );

    // Initial render
    await tester.pumpAndSettle();

    // 1. Header verification
    expect(find.text('إهداء ثواب الأعمال'), findsOneWidget);
    expect(find.text('صلة روحية ونورٌ يُهدى لأهل القبور'), findsOneWidget);

    // 2. Universal recipient fallback
    expect(find.text('عامة موتى المؤمنين والمؤمنات'), findsOneWidget);

    // 3. Action chips exist
    expect(find.text('الفاتحة'), findsOneWidget);
    expect(find.text('تسبيح'), findsOneWidget);
    expect(find.text('دعاء'), findsOneWidget);

    // 4. Tap 'تسبيح' chip to trigger instant dedication
    await tester.tap(find.text('تسبيح'));
    await tester.pumpAndSettle();

    // 5. Verify confirmation state renders
    expect(find.text('تقبّل الله طاعتكم وأصل الثواب'), findsOneWidget);
    expect(find.text('إهداء عمل آخر'), findsOneWidget);
    expect(find.text('عرض السجل'), findsOneWidget);

    // 6. Tap 'إهداء عمل آخر' to return to deed selection
    await tester.tap(find.text('إهداء عمل آخر'));
    await tester.pumpAndSettle();

    // 7. Verify we are back to main interactive content
    expect(find.text('الفاتحة'), findsOneWidget);
    expect(find.text('تسبيح'), findsOneWidget);
    expect(find.text('دعاء'), findsOneWidget);
  });
}
