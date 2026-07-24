import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Native renderer — always uses [SvgPicture.string] since all SVGs are
/// loaded from Isar cache or CDN (never from the filesystem directly).
Widget buildSvgWidget({
  required String svgContent,
  dynamic file,
  BoxFit fit = BoxFit.contain,
  Widget Function(BuildContext)? placeholderBuilder,
  Widget Function(BuildContext, Object, StackTrace)? errorBuilder,
}) {
  return SvgPicture.string(
    svgContent,
    fit: fit,
    placeholderBuilder: placeholderBuilder,
    errorBuilder: errorBuilder,
  );
}
