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
              print('=== CAUGHT ERROR ===');
              print('Type: ${error.runtimeType}');
              print('Message: ${error.toString()}');
              print('Stack:\n$stackTrace');
              return Text('ERROR: ${error.runtimeType}: $error');
            },
            placeholderBuilder: (context) {
              print('=== PLACEHOLDER SHOWN ===');
              return const Text('LOADING...');
            },
          ),
        ),
      ),
    );

    await tester.runAsync(() async {
      await Future.delayed(Duration(seconds: 15));
    });
    await tester.pumpAndSettle();

    if (find.textContaining('ERROR:').evaluate().isNotEmpty) {
      print('=== RESULT: Error widget rendered ===');
      print(
        (find.textContaining('ERROR:').evaluate().first.widget as Text).data,
      );
    } else if (find.text('LOADING...').evaluate().isNotEmpty) {
      print('=== RESULT: Still loading (timed out) ===');
    } else {
      print('=== RESULT: SVG rendered successfully ===');
    }
  });
}
