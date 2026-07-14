import 'dart:io';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart' as vg;

void main() async {
  final file = File('assets/quran/svg/001.svg');
  if (!file.existsSync()) {
    print('ERROR: File not found: ${file.path}');
    return;
  }

  final svgString = file.readAsStringSync();
  print('SVG length: ${svgString.length} chars');
  print('First 200 chars: ${svgString.substring(0, 200)}');

  try {
    final instructions = vg.encodeSvg(
      xml: svgString,
      debugName: 'test',
      enableMaskingOptimizer: false,
      enableClippingOptimizer: false,
      enableOverdrawOptimizer: false,
    );
    print('SUCCESS: Encoded ${instructions.lengthInBytes} bytes');
  } catch (e, s) {
    print('EXCEPTION: $e');
    print('STACK: $s');
  }
}
