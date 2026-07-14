import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  final file = File('assets/quran/svg/001.svg');
  final svgString = await file.readAsString();
  print('SVG loaded: ${svgString.length} chars');
  print('First 200 chars: ${svgString.substring(0, 200)}');

  try {
    final svg = SvgParser().parse(svgString);
    print('Parse SUCCESS');
    print('Root element: ${svg.name}');
    print('Children: ${svg.children.length}');
  } catch (e, s) {
    print('Parse FAILED');
    print('Exception: $e');
    print('Stack: $s');
  }
}
