import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_islamic_widget/app.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: DailyIslamicWidgetApp(),
      ),
    );
    expect(find.byType(DailyIslamicWidgetApp), findsOneWidget);
  });
}
