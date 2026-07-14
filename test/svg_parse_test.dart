import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SvgPicture.asset error is captured', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SvgPicture.asset(
            'assets/quran/svg/001.svg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Text('ERROR: ${error.runtimeType}: $error');
            },
            placeholderBuilder: (context) {
              return const Text('LOADING...');
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.textContaining('ERROR:'), findsOneWidget);
    expect(find.text('LOADING...'), findsNothing);
  });
}
