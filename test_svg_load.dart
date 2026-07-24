import 'dart:io';

void main() async {
  final file = File('assets/quran-svg/svg/001.svg');
  if (await file.exists()) {
    final bytes = await file.readAsBytes();
    print('VEC loaded: ${bytes.length} bytes');
    print('First 20 bytes (hex): ${bytes.take(20).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
  } else {
    print('File not found: ${file.path}');
  }
}
